create table runners(
runner_id int,
registration_date date);

INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

create table customer_orders(
order_id int,
customer_id int,
pizza_id int,
exclusions varchar(4),
extras varchar(4),
order_time datetime
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
  create table runner_orders(
  order_id int,
  runner_id int,
  pickup_time varchar(19),
  distance varchar(7),
  duration varchar(10),
  cancellation varchar(23)
  );

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
  
  CREATE TABLE pizza_names (
  pizza_id INT,
  pizza_name TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_name)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');
  
  CREATE TABLE pizza_recipes (
  pizza_id INT,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

CREATE TABLE pizza_toppings (
  topping_id INT,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  

-- DATA CLEANING
-- drop table customer_orders_temp;
-- creating customer_orders_temp table to clear the null values

create temporary table customer_orders_temp as
select order_id, customer_id, pizza_id,
case
when exclusions is null or exclusions like 'null' then ''
else exclusions
end as exclusions,
case
when extras is null or extras like 'null' then ''
else extras
end as extras, 
order_time
from customer_orders;

select * from customer_orders_temp;
-- creating runner_orders temp table
-- drop temporary table runner_orders_temp;
create temporary table runner_orders_temp(
order_id int,
runner_id int,
pickup_time datetime,
distance float,
duration time,
cancellation text
)

select * from runner_orders;

create temporary table runner_orders_temp as
select order_id, runner_id, 
case
when pickup_time is null or pickup_time like 'null' then ''
else pickup_time end as pickup_time, 
case
when distance is null or distance like 'null' then ''
when distance like '%km' then trim('km' from distance)
else distance end as distance, 
case
when duration is null or duration like 'null' then ''
when duration like '%minutes' then trim('minutes' from duration)
when duration like '%minute' then trim('minute' from duration)
when duration like '%mins' then trim('mins' from duration)
else duration end as duration, 
case
when cancellation is null or cancellation like 'null' then ''
else cancellation end as cancellation 
from runner_orders;

select * from runner_orders_temp;


alter table runner_orders_temp
-- modify column pickup_time datetime;
-- modify column distance float;
modify column duration int;

select * from customer_orders;
 
 -- PART A Metrics 
 -- 1. How many pizzas were ordered?
 select count(order_id) as pizza_ordered from customer_orders;
 
 
 select count(order_id) as pizza_ordered from customer_orders_temp ;
 
 SELECT COUNT(pizza_id) AS pizza_count
FROM customer_orders;
 -- 2. How many unique customer orders were made?
 
 
 
 
 SELECT 
    COUNT(DISTINCT (order_id)) AS unique_orders
FROM
    customer_orders_temp;
 
 
 
 SELECT COUNT(distinct order_id) AS unique_pizza_count
FROM customer_orders;
 
 -- 3. How many successful orders were delivered by each runner?
 select * from runner_orders_temp;
 
 select runner_id,count(order_id) as successful_delivery from runner_orders
 where cancellation is null or cancellation in ('','null')
 group by runner_id;
 
SELECT 
    runner_id, COUNT(order_id) AS successful_delivery
FROM
    runner_orders_temp
WHERE
    cancellation = ''
GROUP BY runner_id;
 
 -- 4. How many of each type of pizza was delivered? 
 select pizza_name, count(c.pizza_id) from customer_orders c
 join runner_orders r on c.order_id = r.order_id
 join pizza_names p on c.pizza_id = p.pizza_id
 where r.cancellation is null or r.cancellation in ('','null')
 group by pizza_name;
 
 SELECT 
    pizza_name, COUNT(c.pizza_id)
FROM
    customer_orders_temp c
        JOIN
    runner_orders_temp r ON c.order_id = r.order_id
        JOIN
    pizza_names p ON c.pizza_id = p.pizza_id
WHERE
    r.cancellation = ''
GROUP BY pizza_name;
 
 -- 5. How many Vegetarian and Meatlovers were ordered by each customer?
 
SELECT 
    customer_id, pizza_name, COUNT(c.pizza_id)
FROM
    customer_orders_temp c
        JOIN
    pizza_names p ON c.pizza_id = p.pizza_id
GROUP BY customer_id , pizza_name
ORDER BY 1;

-- 6. What was the maximum number of pizzas delivered in a single order?

 SELECT 
    r.order_id, COUNT(c.pizza_id)
FROM
    customer_orders_temp c
        JOIN
    runner_orders_temp r ON c.order_id = r.order_id
WHERE
    r.cancellation = ''
GROUP BY r.order_id
ORDER BY 2 DESC;

 -- limit 1;
 
 -- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
 select c.customer_id,c.pizza_id -- count(c.pizza_id),count(c.customer_id)
 from customer_orders_temp c
 join runner_orders_temp r on c.order_id = r.order_id
 where r.cancellation = ''
 order by 1;
 -- group by c.customer_id,c.pizza_id;
  
  
-- 8. How many pizzas were delivered that had both exclusions and extras?

SELECT 
    COUNT(*) AS exclusion_extras
FROM
    customer_orders_temp c
        JOIN
    runner_orders_temp r ON c.order_id = r.order_id
WHERE
    cancellation = ''
        AND LENGTH(exclusions) > 0
        AND LENGTH(extras) > 0;

select c.order_id,exclusions,length(exclusions),extras,length(extras) -- count(c.pizza_id),count(c.customer_id)
 from customer_orders c
 join runner_orders r on c.order_id = r.order_id
 where r.cancellation is null or r.cancellation in ('','null')
 and (length(exclusions) != 0 and exclusions != 'null')
 and (length(extras) != 0 and extras != 'null');
 
 SELECT  
  SUM(
    CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1
    ELSE 0
    END) AS pizza_count_w_exclusions_extras
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
WHERE r.distance >= 1 
  AND exclusions <> ' ' 
  AND extras <> ' ' 
 and ((exclusions != 'null')) -- and (exclusions != '' ) and (exclusions != 'null'));
 and (extras is not null); -- and extras not in ('','null'));
 
 -- 9. What was the total volume of pizzas ordered for each hour of the day?
 
  SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    customer_orders_temp
GROUP BY HOUR(order_time);

  
 -- 10. What was the volume of orders for each day of the week?
 
 with week_day as
 (select weekday(order_time) as days, count(order_id) as order_count
 from customer_orders_temp group by weekday(order_time))
  select order_count,
 case
 when days=0 then 'Sunday'
  when days=1 then 'Monday'
   when days=2 then 'Tuesday'
    when days=3 then 'Wednesday'
     when days=4 then 'Thursday'
      when days=5 then 'Friday'
       when days=6 then 'Saturday'
       END as week_days
 from week_day;
 
 -- PART 2 RUNNER AND CUSTOMER EXPERIENCE
 
-- How many runners signed up for each 1 week period?

select week(registration_date) as week_num,count(runner_id) as runners_registered from runners
group by week(registration_date);

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select runner_id,avg(minute((timediff(pickup_time,order_time)))) from runner_orders_temp r
join customer_orders_temp c on r.order_id = c.order_id
group by runner_id;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
select distinct(c.order_id),
minute((timediff(pickup_time,order_time)))/count(c.pizza_id)over(partition by c.order_id) as time_gap from runner_orders_temp r
join customer_orders_temp c on r.order_id = c.order_id;
-- group by c.order_id;

-- What was the average distance travelled for each customer?
select c.customer_id,round(avg(r.distance),2) as avg_distance from customer_orders_temp c
join runner_orders_temp r on c.order_id = r.order_id
where cancellation = ''
group by c.customer_id;

-- What was the difference between the longest and shortest delivery times for all orders?
select max(duration)-min(duration) as diff_long_short_delivery from runner_orders_temp
where duration != '';

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
select r.runner_id,sum(distance),sum(duration),sum(distance)/sum(duration) from runner_orders_temp r
where cancellation = ''  group by runner_id;

-- My understanding here is that 2 runner_id id delivery is fast compared to others

-- What is the successful delivery percentage for each runner?
with success_cancel_count as
(select runner_id,
sum(
case when length(cancellation)= 0 then 1 end
) as success_delivery,
sum(
case when cancellation != '' then 1 
else 0 end 
) as cancelled_orders
from runner_orders_temp
group by runner_id)

select runner_id,(success_delivery*100)/(success_delivery+cancelled_orders) as success_per
from success_cancel_count;

/*
-- Ingredient Opimization

-- What are the standard ingredients for each pizza?
select *,substring_index(toppings,',',1) as top1,
substring_index(substring_index(toppings,',',2),',',-1) as top2
 from pizza_recipes pr
join pizza_toppings pt on pr.toppings = pt.topping_id;
select * from pizza_toppings;

help delimiter;

-- What was the most commonly added extra?
select extras,count(extras) from customer_orders_temp
group by extras;

select extras from customer_orders_temp;
*/