ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY';

DROP TABLE GUEST CASCADE CONSTRAINTS;
DROP TABLE HOST CASCADE CONSTRAINTS;
DROP TABLE PROPERTY CASCADE CONSTRAINTS;
DROP TABLE BOOKING CASCADE CONSTRAINTS;
DROP TABLE REVIEW CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE FACILITY CASCADE CONSTRAINTS;
DROP TABLE PropertyFacility CASCADE CONSTRAINTS;

-- Create the GUEST table
CREATE TABLE GUEST (
    GuestID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Phone VARCHAR2(15),
    DateOfBirth DATE NOT NULL,
    JoinDate DATE NOT NULL
);

-- Create the HOST table
CREATE TABLE HOST (
    HostID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Phone VARCHAR2(15),
    DateOfBirth DATE NOT NULL,
    JoinDate DATE NOT NULL
);

-- Create the Property table
CREATE TABLE PROPERTY (
    PropertyID NUMBER PRIMARY KEY,
    HostID NUMBER NOT NULL,
    PropertyType VARCHAR2(50),
    NumBedroom NUMBER,
    Description VARCHAR2(255),
    Street VARCHAR2(200),
    State VARCHAR2(100),
    PricePerNight NUMBER,
    Status VARCHAR2(10) CHECK (Status IN ('Reserved', 'Available')),
    FOREIGN KEY (HostID) REFERENCES Host(HostID)
);

-- Create the Booking table
CREATE TABLE BOOKING(
    BookingID NUMBER PRIMARY KEY,
    PropertyID NUMBER NOT NULL,
    GuestID NUMBER NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    BookingStatus VARCHAR2(10) CHECK (BookingStatus IN ('Pending', 'Confirmed', 'Cancelled')),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)
);

-- Create the Review table
CREATE TABLE REVIEW(
    ReviewID NUMBER PRIMARY KEY,
    GuestID NUMBER NOT NULL,
    BookingID NUMBER NOT NULL,
    ReviewDate DATE NOT NULL,
    Rating NUMBER CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR2(250),
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

-- Create the Payment table
CREATE TABLE PAYMENT(
    PaymentID NUMBER PRIMARY KEY,
    BookingID NUMBER NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR2(20) CHECK (PaymentMethod IN ('Credit Card', 'PayPal', 'Bank Transfer', 'Touch ''n Go')),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

-- Create the Facility table
CREATE TABLE FACILITY (
    FacilityID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    OpeningHours VARCHAR2(10),
    ClosingHours VARCHAR2(10),
    Rules VARCHAR2(255)
);

-- Create the PropertyFacility table
CREATE TABLE PropertyFacility (
    PropertyID NUMBER NOT NULL,
    FacilityID NUMBER NOT NULL,
    PRIMARY KEY (PropertyID, FacilityID),
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID),
    FOREIGN KEY (FacilityID) REFERENCES Facility(FacilityID)
);

CREATE INDEX idx_booking_status ON Booking(BookingStatus);
CREATE INDEX idx_property_type_status ON Property(PropertyType, Status);
CREATE INDEX idx_review_property_rating ON Review(BookingID, Rating);
CREATE INDEX idx_booking_guest_checkindate ON Booking(GuestID, CheckInDate);
CREATE INDEX idx_property_num_bedroom ON Property(NumBedroom);

-- Create a trigger to enforce the age constraint. Ensure age is at least 18 years for Guest
CREATE OR REPLACE TRIGGER trg_guest_age_check
BEFORE INSERT OR UPDATE ON GUEST
FOR EACH ROW
BEGIN
    IF TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.DateOfBirth) / 12) < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Guest must be at least 18 years old.');
    END IF;
END;
/

-- Create a trigger to enforce the age constraint. Ensure age is at least 18 years for Host
CREATE OR REPLACE TRIGGER trg_host_age_check
BEFORE INSERT OR UPDATE ON HOST
FOR EACH ROW
BEGIN
    IF TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.DateOfBirth) / 12) < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Host must be at least 18 years old.');
    END IF;
END;
/

-- Insert records into the GUEST table (NON-EVENT TABLE)
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0001, 'Bob Smith', 'bob.smith@example.com', '441234567890', TO_DATE('1985-11-20', 'YYYY-MM-DD'), TO_DATE('2019-12-05', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0002, 'David Wilson', 'david.wilson@example.com', '12123456792', TO_DATE('1988-02-25', 'YYYY-MM-DD'), TO_DATE('2021-01-19', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0003, 'Frank Harris', 'frank.harris@example.com', '33123456794', TO_DATE('1991-04-22', 'YYYY-MM-DD'), TO_DATE('2022-02-14', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0004, 'Hannah Moore', 'hannah.moore@example.com', '49123456796', TO_DATE('1993-03-11', 'YYYY-MM-DD'), TO_DATE('2023-07-04', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0005, 'Judy Anderson', 'judy.anderson@example.com', '81123456798', TO_DATE('1994-10-14', 'YYYY-MM-DD'), TO_DATE('2024-05-22', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0006, 'Laura Jackson', 'laura.jackson@example.com', '61123456800', TO_DATE('1986-08-19', 'YYYY-MM-DD'), TO_DATE('2021-01-29', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0007, 'Nina Martinez', 'nina.martinez@example.com', '34123456802', TO_DATE('1992-06-12', 'YYYY-MM-DD'), TO_DATE('2022-04-01', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0008, 'Paul Clark', 'paul.clark@example.com', '0123456804', TO_DATE('1990-03-15', 'YYYY-MM-DD'), TO_DATE('2018-09-08', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0009, 'Rachel Walker', 'rachel.walker@example.com', '0123456806', TO_DATE('1991-12-30', 'YYYY-MM-DD'), TO_DATE('2023-06-02', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0010, 'Tina Allen', 'tina.allen@example.com', '0123456808', TO_DATE('1992-01-11', 'YYYY-MM-DD'), TO_DATE('2024-02-23', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0011, 'Andrew Baker', 'andrew.baker@example.com', '0123456810', TO_DATE('1991-11-11', 'YYYY-MM-DD'), TO_DATE('2023-03-10', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0012, 'Catherine Lee', 'catherine.lee@example.com', '0123456812', TO_DATE('1989-09-05', 'YYYY-MM-DD'), TO_DATE('2019-04-15', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0013, 'Derek Carter', 'derek.carter@example.com', '0123456814', TO_DATE('1987-02-20', 'YYYY-MM-DD'), TO_DATE('2021-06-05', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0014, 'Eva Green', 'eva.green@example.com', '0123456816', TO_DATE('1990-12-17', 'YYYY-MM-DD'), TO_DATE('2020-08-22', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0015, 'George Young', 'george.young@example.com', '0123456818', TO_DATE('1988-04-10', 'YYYY-MM-DD'), TO_DATE('2018-11-13', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0016, 'Helen Scott', 'helen.scott@example.com', '0123456820', TO_DATE('1993-07-08', 'YYYY-MM-DD'), TO_DATE('2023-12-29', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0017, 'Isaac Adams', 'isaac.adams@example.com', '0123456822', TO_DATE('1994-03-23', 'YYYY-MM-DD'), TO_DATE('2024-01-25', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0018, 'Julia Collins', 'julia.collins@example.com', '0123456824', TO_DATE('1991-06-01', 'YYYY-MM-DD'), TO_DATE('2021-05-20', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0019, 'Kurt Rogers', 'kurt.rogers@example.com', '0123456826', TO_DATE('1986-10-29', 'YYYY-MM-DD'), TO_DATE('2019-01-16', 'YYYY-MM-DD'));
INSERT INTO GUEST (GuestID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (0020, 'Laura Johnson', 'laura.johnson@example.com', '0123456828', TO_DATE('1990-03-14', 'YYYY-MM-DD'), TO_DATE('2020-02-28', 'YYYY-MM-DD'));

-- Insert records into the HOST table (NON-EVENT TABLE)
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9001, 'Alice Johnson', 'alice.johnson@example.com', '0123456789', TO_DATE('1990-05-15', 'YYYY-MM-DD'), TO_DATE('2018-06-10', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9002, 'Carol Brown', 'carol.brown@example.com', '0123456791', TO_DATE('1992-07-30', 'YYYY-MM-DD'), TO_DATE('2020-03-22', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9003, 'Emily Davis', 'emily.davis@example.com', '0123456793', TO_DATE('1995-09-10', 'YYYY-MM-DD'), TO_DATE('2019-09-30', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9004, 'Grace Miller', 'grace.miller@example.com', '0123456795', TO_DATE('1989-06-17', 'YYYY-MM-DD'), TO_DATE('2018-08-25', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9005, 'Ian Taylor', 'ian.taylor@example.com', '0123456797', TO_DATE('1987-12-05', 'YYYY-MM-DD'), TO_DATE('2024-03-11', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9006, 'Kevin Thomas', 'kevin.thomas@example.com', '0123456799', TO_DATE('1991-01-30', 'YYYY-MM-DD'), TO_DATE('2020-10-15', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9007, 'Michael White', 'michael.white@example.com', '0123456801', TO_DATE('1993-09-03', 'YYYY-MM-DD'), TO_DATE('2020-12-20', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9008, 'Natalie Green', 'natalie.green@example.com', '0123456803', TO_DATE('1988-11-22', 'YYYY-MM-DD'), TO_DATE('2023-02-14', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9009, 'Oliver Scott', 'oliver.scott@example.com', '0123456805', TO_DATE('1990-04-30', 'YYYY-MM-DD'), TO_DATE('2023-06-20', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9010, 'Pamela Young', 'pamela.young@example.com', '0123456807', TO_DATE('1985-08-15', 'YYYY-MM-DD'), TO_DATE('2019-11-12', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9011, 'Quinn Adams', 'quinn.adams@example.com', '0123456809', TO_DATE('1992-12-25', 'YYYY-MM-DD'), TO_DATE('2023-05-16', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9012, 'Rebecca Lewis', 'rebecca.lewis@example.com', '0123456811', TO_DATE('1991-07-04', 'YYYY-MM-DD'), TO_DATE('2020-01-30', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9013, 'Samuel Martin', 'samuel.martin@example.com', '0123456813', TO_DATE('1989-03-19', 'YYYY-MM-DD'), TO_DATE('2023-08-14', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9014, 'Tina Walker', 'tina.walker@example.com', '0123456815', TO_DATE('1986-10-02', 'YYYY-MM-DD'), TO_DATE('2021-07-05', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9015, 'Ursula Hall', 'ursula.hall@example.com', '0123456817', TO_DATE('1994-01-18', 'YYYY-MM-DD'), TO_DATE('2023-03-08', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9016, 'Victor Nelson', 'victor.nelson@example.com', '0123456819', TO_DATE('1983-12-01', 'YYYY-MM-DD'), TO_DATE('2022-11-20', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9017, 'Wendy Harris', 'wendy.harris@example.com', '0123456821', TO_DATE('1987-06-12', 'YYYY-MM-DD'), TO_DATE('2021-04-17', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9018, 'Xander Taylor', 'xander.taylor@example.com', '0123456823', TO_DATE('1995-09-09', 'YYYY-MM-DD'), TO_DATE('2023-12-25', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9019, 'Yvonne Moore', 'yvonne.moore@example.com', '0123456825', TO_DATE('1993-05-21', 'YYYY-MM-DD'), TO_DATE('2020-08-30', 'YYYY-MM-DD'));
INSERT INTO HOST (HostID, Name, Email, Phone, DateOfBirth, JoinDate) VALUES (9020, 'Zachary King', 'zachary.king@example.com', '0123456827', TO_DATE('1994-11-12', 'YYYY-MM-DD'), TO_DATE('2024-03-23', 'YYYY-MM-DD'));


-- Insert records into Property table (EVENT TABLE)
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (100, 9001, 'Apartment', 2, 'Underwater theme apartment that kids will love.', '123 Main St', 'Malacca', 100, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (200, 9002, 'House', 4, 'Spacious house with a garden theme.', '456 Elm St', 'Kuala Lumpur', 150, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (300, 9003, 'Condo', 3, 'Modern theme condo with sea view.', '789 Pine St', 'Langkawi', 200, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (400, 9004, 'Apartment', 1, 'Small apartment near the beach.', '101 Maple St', 'Kota Kinabalu', 90, 'Reserved');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (500, 9005, 'Villa', 5, 'Luxury villa with private pool.', '202 Oak St', 'Kuching', 300, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (600, 9006, 'Studio', 1, 'Charming studio with theme in a quiet neighborhood.', '303 Birch St', 'Johor Bahru', 80, 'Reserved');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (700, 9007, 'House', 3, 'Family-friendly house with a yard.', '404 Cedar St', 'Malacca', 120, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (800, 9008, 'Apartment', 2, 'Stylish theme apartment with city view.', '505 Walnut St', 'Malacca', 110, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (900, 9009, 'Condo', 3, 'Anime theme condo with amenities.', '606 Chestnut St', 'Langkawi', 130, 'Reserved');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1000, 9010, 'Villa', 4, 'Elegant villa with garden and terrace.', '707 Ash St', 'Langkawi', 250, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1100, 9011, 'House', 2, 'Cozy house close to local attractions.', '808 Elm St', 'Kota Kinabalu', 140, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1200, 9012, 'Apartment', 1, 'Compact apartment ideal for solo travelers.', '909 Pine St', 'Kuching', 70, 'Reserved');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1300, 9013, 'Condo', 2, 'Condo with minimalist theme.', '123 Maple St', 'Langkawi', 95, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1400, 9014, 'Villa', 5, 'Luxurious villa with modern theme and stunning views.', '234 Oak St', 'Penang', 350, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1500, 9015, 'Studio', 1, 'Studio with a comfortable design.', '345 Birch St', 'Kuala Lumpur', 85, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1600, 9016, 'House', 4, 'Spacious house with large living areas.', '456 Cedar St', 'Penang', 160, 'Reserved');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1700, 9017, 'Condo', 3, 'Cozy condo with a fantastic location.', '567 Walnut St', 'Langkawi', 140, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1800, 9018, 'Villa', 6, 'Beautiful villa with rustic theme.', '678 Chestnut St', 'Penang', 275, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (1900, 9019, 'Apartment', 2, 'Modern apartment with great amenities.', '789 Ash St', 'Malacca', 105, 'Available');
INSERT INTO PROPERTY (PropertyID, HostID, PropertyType, NumBedroom, Description, Street, State, PricePerNight, Status) VALUES (2000, 9020, 'House', 3, 'Jungle Treehouse theme with easy access to attractions.', '890 Elm St', 'Kuala Lumpur', 125, 'Available');


-- Booking records for GuestID 0001 (3 bookings within the same year)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (1, 200, 0001, TO_DATE('2024-01-11', 'YYYY-MM-DD'), TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (2, 300, 0001, TO_DATE('2024-05-18', 'YYYY-MM-DD'), TO_DATE('2024-05-25', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (3, 400, 0001, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0002 (4 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (4, 600, 0002, TO_DATE('2021-08-01', 'YYYY-MM-DD'), TO_DATE('2021-08-05', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (5, 700, 0002, TO_DATE('2021-09-13', 'YYYY-MM-DD'), TO_DATE('2021-09-17', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (6, 800, 0002, TO_DATE('2023-05-04', 'YYYY-MM-DD'), TO_DATE('2023-05-06', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (7, 900, 0002, TO_DATE('2023-12-23', 'YYYY-MM-DD'), TO_DATE('2023-12-25', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0003 (3 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (8, 1000, 0003, TO_DATE('2021-01-15', 'YYYY-MM-DD'), TO_DATE('2021-01-25', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (9, 1100, 0003, TO_DATE('2024-02-11', 'YYYY-MM-DD'), TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (10, 1200, 0003, TO_DATE('2021-07-21', 'YYYY-MM-DD'), TO_DATE('2021-07-25', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0004 (4 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (11, 1300, 0004, TO_DATE('2024-05-22', 'YYYY-MM-DD'), TO_DATE('2024-05-29', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (12, 1400, 0004, TO_DATE('2022-06-21', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (13, 1500, 0004, TO_DATE('2024-07-27', 'YYYY-MM-DD'), TO_DATE('2024-07-31', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (14, 1600, 0004, TO_DATE('2023-08-02', 'YYYY-MM-DD'), TO_DATE('2023-08-05', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0005 (3 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (15, 1700, 0005, TO_DATE('2021-07-16', 'YYYY-MM-DD'), TO_DATE('2021-07-19', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (16, 1800, 0005, TO_DATE('2024-08-20', 'YYYY-MM-DD'), TO_DATE('2024-08-23', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (17, 1900, 0005, TO_DATE('2020-09-23', 'YYYY-MM-DD'), TO_DATE('2020-09-25', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0006 (5 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (18, 2000, 0006, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (19, 100, 0006, TO_DATE('2019-11-30', 'YYYY-MM-DD'), TO_DATE('2019-12-05', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (20, 200, 0006, TO_DATE('2020-01-03', 'YYYY-MM-DD'), TO_DATE('2020-01-05', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (21, 300, 0006, TO_DATE('2019-12-15', 'YYYY-MM-DD'), TO_DATE('2019-12-25', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (22, 400, 0006, TO_DATE('2020-03-24', 'YYYY-MM-DD'), TO_DATE('2020-03-27', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0007 (1 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (23, 600, 0007, TO_DATE('2020-11-11', 'YYYY-MM-DD'), TO_DATE('2020-11-16', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0008 (3 bookings within the same year and 1 booking across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (24, 700, 0008, TO_DATE('2021-07-21', 'YYYY-MM-DD'), TO_DATE('2021-07-25', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (25, 800, 0008, TO_DATE('2023-08-23', 'YYYY-MM-DD'), TO_DATE('2023-08-28', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (26, 900, 0008, TO_DATE('2023-09-12', 'YYYY-MM-DD'), TO_DATE('2023-09-18', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (27, 1000, 0008, TO_DATE('2023-10-14', 'YYYY-MM-DD'), TO_DATE('2023-10-17', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0009 (5 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (28, 1100, 0009, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-06-08', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (29, 1200, 0009, TO_DATE('2021-06-09', 'YYYY-MM-DD'), TO_DATE('2021-06-13', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (30, 1300, 0009, TO_DATE('2024-02-17', 'YYYY-MM-DD'), TO_DATE('2024-02-22', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (31, 1400, 0009, TO_DATE('2022-09-07', 'YYYY-MM-DD'), TO_DATE('2022-09-10', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (32, 1500, 0009, TO_DATE('2023-11-25', 'YYYY-MM-DD'), TO_DATE('2023-11-28', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0010 (3 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (33, 1600, 0010, TO_DATE('2023-11-02', 'YYYY-MM-DD'), TO_DATE('2023-11-05', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (34, 1700, 0010, TO_DATE('2023-12-12', 'YYYY-MM-DD'), TO_DATE('2023-12-14', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (35, 1800, 0011, TO_DATE('2024-03-24', 'YYYY-MM-DD'), TO_DATE('2024-03-29', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0011 (2 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (36, 1900, 0011, TO_DATE('2021-04-11', 'YYYY-MM-DD'), TO_DATE('2021-04-15', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (37, 2000, 0011, TO_DATE('2024-05-10', 'YYYY-MM-DD'), TO_DATE('2024-05-16', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0012 (4 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (38, 100, 0012, TO_DATE('2019-06-02', 'YYYY-MM-DD'), TO_DATE('2019-06-05', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (39, 200, 0012, TO_DATE('2020-06-19', 'YYYY-MM-DD'), TO_DATE('2020-06-23', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (40, 300, 0012, TO_DATE('2021-07-27', 'YYYY-MM-DD'), TO_DATE('2021-07-30', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (41, 400, 0012, TO_DATE('2023-09-21', 'YYYY-MM-DD'), TO_DATE('2023-09-24', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0013 (2 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (42, 600, 0013, TO_DATE('2020-12-14', 'YYYY-MM-DD'), TO_DATE('2020-12-17', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (43, 700, 0013, TO_DATE('2023-01-23', 'YYYY-MM-DD'), TO_DATE('2023-01-26', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0014 (2 bookings within the same year)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (44, 800, 0014, TO_DATE('2023-04-11', 'YYYY-MM-DD'), TO_DATE('2023-04-15', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (45, 900, 0014, TO_DATE('2024-03-18', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0015 (3 bookings within the same year)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (46, 1000, 0015, TO_DATE('2023-01-13', 'YYYY-MM-DD'), TO_DATE('2023-01-16', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (47, 1100, 0015, TO_DATE('2023-08-04', 'YYYY-MM-DD'), TO_DATE('2023-08-08', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (48, 1200, 0015, TO_DATE('2023-04-06', 'YYYY-MM-DD'), TO_DATE('2023-04-09', 'YYYY-MM-DD'), 'Confirmed');


-- Booking records for GuestID 0016 (3 bookings within the same year and 1 booking across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (49, 1300, 0016, TO_DATE('2024-05-30', 'YYYY-MM-DD'), TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (50, 1400, 0016, TO_DATE('2023-06-15', 'YYYY-MM-DD'), TO_DATE('2023-06-17', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (51, 1500, 0016, TO_DATE('2023-07-19', 'YYYY-MM-DD'), TO_DATE('2023-07-23', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (52, 1600, 0016, TO_DATE('2023-09-21', 'YYYY-MM-DD'), TO_DATE('2023-09-26', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0017 (2 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (53, 1700, 0017, TO_DATE('2022-10-05', 'YYYY-MM-DD'), TO_DATE('2022-10-07', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (54, 1800, 0017, TO_DATE('2024-01-22', 'YYYY-MM-DD'), TO_DATE('2024-01-24', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0018 (4 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (55, 1900, 0018, TO_DATE('2020-12-23', 'YYYY-MM-DD'), TO_DATE('2020-12-25', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (56, 2000, 0018, TO_DATE('2024-05-08', 'YYYY-MM-DD'), TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (57, 100, 0018, TO_DATE('2019-05-20', 'YYYY-MM-DD'), TO_DATE('2019-05-23', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (58, 200, 0018, TO_DATE('2021-06-10', 'YYYY-MM-DD'), TO_DATE('2021-06-17', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0019 (4 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (59, 300, 0019, TO_DATE('2020-07-01', 'YYYY-MM-DD'), TO_DATE('2020-07-04', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (60, 400, 0019, TO_DATE('2019-10-11', 'YYYY-MM-DD'), TO_DATE('2019-10-20', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (61, 600, 0019, TO_DATE('2021-12-22', 'YYYY-MM-DD'), TO_DATE('2021-12-26', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (62, 700, 0019, TO_DATE('2022-01-06', 'YYYY-MM-DD'), TO_DATE('2022-01-10', 'YYYY-MM-DD'), 'Confirmed');

-- Booking records for GuestID 0020 (3 bookings across different years)
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (63, 800, 0020, TO_DATE('2023-03-28', 'YYYY-MM-DD'), TO_DATE('2023-04-01', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (64, 900, 0020, TO_DATE('2023-07-18', 'YYYY-MM-DD'), TO_DATE('2023-07-22', 'YYYY-MM-DD'), 'Confirmed');
INSERT INTO BOOKING (BookingID, PropertyID, GuestID, CheckInDate, CheckOutDate, BookingStatus) VALUES (65, 1000, 0020, TO_DATE('2022-05-13', 'YYYY-MM-DD'), TO_DATE('2022-05-25', 'YYYY-MM-DD'), 'Confirmed');

-- Insert records into the REVIEW table
-- Review for Guest 0001
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3301, 0001, 1, TO_DATE('2024-03-04', 'YYYY-MM-DD'), 4, 'Great place, would stay again.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3302, 0001, 2, TO_DATE('2024-05-27', 'YYYY-MM-DD'), 5, 'Perfect stay, highly recommend!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3303, 0001, 3, TO_DATE('2024-04-26', 'YYYY-MM-DD'), 3, 'Average experience, not as expected.');

-- Review for Guest 0002

INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3305, 0002, 4, TO_DATE('2021-08-16', 'YYYY-MM-DD'), 5, 'Amazing villa, worth every penny!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3306, 0002, 5, TO_DATE('2021-09-26', 'YYYY-MM-DD'), 2, 'Not satisfied with the cleanliness.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3307, 0002, 6, TO_DATE('2023-05-08', 'YYYY-MM-DD'), 4, 'Great location, comfortable stay.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3308, 0002, 7, TO_DATE('2024-01-03', 'YYYY-MM-DD'), 3, 'Decent place, but noisy at night.');

-- Review for Guest 0003
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3309, 0003, 8, TO_DATE('2021-01-27', 'YYYY-MM-DD'), 5, 'Wonderful stay, will come back.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3310, 0003, 9, TO_DATE('2024-02-24', 'YYYY-MM-DD'), 4, 'Good value for money.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3311, 0003, 10, TO_DATE('2021-07-28', 'YYYY-MM-DD'), 1, 'The place was nothing like the photos.');

-- Review for Guest 0004
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3312, 0004, 11, TO_DATE('2024-06-03', 'YYYY-MM-DD'), 3, 'The place was okay, could be better.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3313, 0004, 12, TO_DATE('2022-07-07', 'YYYY-MM-DD'), 4, 'Nice and cozy, enjoyed our stay.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3314, 0004, 13, TO_DATE('2024-08-17', 'YYYY-MM-DD'), 2, 'Disappointing experience.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3315, 0004, 14, TO_DATE('2023-08-27', 'YYYY-MM-DD'), 5, 'Fantastic villa, great amenities.');

-- Review for Guest 0005
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3316, 0005, 15, TO_DATE('2021-07-20', 'YYYY-MM-DD'), 4, 'Very good place, minor issues.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3317, 0005, 16, TO_DATE('2024-08-27', 'YYYY-MM-DD'), 3, 'Average experience, okay stay.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3318, 0005, 17, TO_DATE('2020-09-29', 'YYYY-MM-DD'), 4, 'Good place, would stay again.');

-- Review for Guest 0006
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3319, 0006, 18, TO_DATE('2024-06-08', 'YYYY-MM-DD'), 5, 'Excellent, will return!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3320, 0006, 19, TO_DATE('2019-12-16', 'YYYY-MM-DD'), 4, 'Nice villa, enjoyed the stay.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3321, 0006, 20, TO_DATE('2020-01-15', 'YYYY-MM-DD'), 5, 'Excellent stay, highly recommend!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3322, 0006, 21, TO_DATE('2020-01-28', 'YYYY-MM-DD'), 4, 'Very good, but could use some improvements.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3323, 0006, 22, TO_DATE('2020-03-28', 'YYYY-MM-DD'), 3, 'Average experience.');


-- Review for Guest 0008
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3326, 0008, 24, TO_DATE('2021-08-12', 'YYYY-MM-DD'), 5, 'Fantastic stay!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3327, 0008, 25, TO_DATE('2023-08-30', 'YYYY-MM-DD'), 4, 'Very nice place.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3328, 0008, 26, TO_DATE('2023-09-25', 'YYYY-MM-DD'), 3, 'Decent experience.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3329, 0008, 27, TO_DATE('2023-10-24', 'YYYY-MM-DD'), 4, 'Comfortable stay.');

-- Review for Guest 0009
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3330, 0009, 28, TO_DATE('2024-06-15', 'YYYY-MM-DD'), 5, 'Exceptional service!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3331, 0009, 29, TO_DATE('2021-06-15', 'YYYY-MM-DD'), 2, 'The host was unresponsive and rude.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3332, 0009, 30, TO_DATE('2024-02-26', 'YYYY-MM-DD'), 3, 'Average, nothing special.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3333, 0009, 31, TO_DATE('2022-09-15', 'YYYY-MM-DD'), 2, 'Not up to the mark.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3334, 0009, 32, TO_DATE('2023-11-30', 'YYYY-MM-DD'), 1, 'Found a cockroach in the bathroom');

-- Review for Guest 0010
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3335, 0010, 33, TO_DATE('2023-11-25', 'YYYY-MM-DD'), 4, 'Great experience overall.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3336, 0010, 34, TO_DATE('2023-12-23', 'YYYY-MM-DD'), 3, 'Average, could be better.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3337, 0010, 35, TO_DATE('2024-04-02', 'YYYY-MM-DD'), 5, 'Wonderful stay, loved it!');

-- Review for Guest 0011
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3338, 0011, 36, TO_DATE('2021-04-23', 'YYYY-MM-DD'), 2, 'Not satisfied, poor service.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3339, 0011, 37, TO_DATE('2024-05-27', 'YYYY-MM-DD'), 4, 'Good stay, minor issues.');

-- Review for Guest 0012
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3340, 0012, 38, TO_DATE('2019-06-14', 'YYYY-MM-DD'), 5, 'Perfect stay, highly recommend!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3341, 0012, 39, TO_DATE('2020-06-26', 'YYYY-MM-DD'), 3, 'Average, could use some upgrades.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3342, 0012, 40, TO_DATE('2021-08-02', 'YYYY-MM-DD'), 4, 'Good stay, would come back.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3343, 0012, 41, TO_DATE('2023-10-04', 'YYYY-MM-DD'), 5, 'Excellent experience, loved it.');

-- Review for Guest 0013
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3345, 0013, 42, TO_DATE('2024-12-19', 'YYYY-MM-DD'), 2, 'Rooms misleading as they were not as described');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3346, 0013, 43, TO_DATE('2023-01-29', 'YYYY-MM-DD'), 3, 'Decent stay, nothing special.');

-- Review for Guest 0014
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3347, 0014, 44, TO_DATE('2023-04-17', 'YYYY-MM-DD'), 4, 'Good experience overall.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3348, 0014, 45, TO_DATE('2024-03-24', 'YYYY-MM-DD'), 2, 'Poor experience, not as advertised.');

-- Review for Guest 0015
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3349, 0015, 46, TO_DATE('2023-01-19', 'YYYY-MM-DD'), 3, 'Average stay, could improve.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3350, 0015, 47, TO_DATE('2023-09-09', 'YYYY-MM-DD'), 4, 'Good stay, would recommend.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3351, 0015, 48, TO_DATE('2023-04-12', 'YYYY-MM-DD'), 2, 'Price reflects the poor quality.');

-- Review for Guest 0016
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3352, 0016, 49, TO_DATE('2024-06-07', 'YYYY-MM-DD'), 4, 'Very good, but room for improvement.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3353, 0016, 50, TO_DATE('2023-06-20', 'YYYY-MM-DD'), 3, 'Decent stay, not exceptional.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3354, 0016, 51, TO_DATE('2023-07-28', 'YYYY-MM-DD'), 1, 'Rooms and toilets were not clean');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3355, 0016, 52, TO_DATE('2023-09-30', 'YYYY-MM-DD'), 4, 'Good stay, would come back.');

-- Review for Guest 0017
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3356, 0017, 53, TO_DATE('2022-10-15', 'YYYY-MM-DD'), 3, 'Average stay, not outstanding.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3357, 0017, 54, TO_DATE('2024-01-27', 'YYYY-MM-DD'), 5, 'Fantastic service, very satisfied.');

-- Review for Guest 0018
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3358, 0018, 55, TO_DATE('2020-12-26', 'YYYY-MM-DD'), 4, 'Good value for money.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3359, 0018, 56, TO_DATE('2024-05-18', 'YYYY-MM-DD'), 5, 'Great stay, will return.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3360, 0018, 57, TO_DATE('2019-05-24', 'YYYY-MM-DD'), 3, 'Decent, but could be better.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3361, 0018, 58, TO_DATE('2021-06-19', 'YYYY-MM-DD'), 2, 'Not great, poor service.');

-- Review for Guest 0019
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3362, 0019, 59, TO_DATE('2020-07-07', 'YYYY-MM-DD'), 4, 'Good stay, enjoyed it.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3363, 0019, 60, TO_DATE('2019-10-25', 'YYYY-MM-DD'), 5, 'Excellent stay, highly recommend!');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3365, 0019, 61, TO_DATE('2021-12-30', 'YYYY-MM-DD'), 2, 'Not satisfied with the stay.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3366, 0019, 62, TO_DATE('2022-01-31', 'YYYY-MM-DD'), 4, 'Good experience, would stay again.');

-- Review for Guest 0020
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3367, 0020, 63, TO_DATE('2023-04-12', 'YYYY-MM-DD'), 5, 'Exceptional stay, very happy.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3368, 0020, 64, TO_DATE('2023-07-23', 'YYYY-MM-DD'), 4, 'Very good, minor issues.');
INSERT INTO REVIEW (ReviewID, GuestID, BookingID, ReviewDate, Rating, Comments) VALUES (3369, 0020, 65, TO_DATE('2022-05-27', 'YYYY-MM-DD'), 3, 'Average stay, not outstanding.');

-- Insert records into the PAYMENT table
-- Payment for Guest 0001
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6001, 1, TO_DATE('2024-01-09', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6002, 2, TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6003, 3, TO_DATE('2024-03-29', 'YYYY-MM-DD'), 'Credit Card');

-- Payment for Guest 0002
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6004, 4, TO_DATE('2021-07-28', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6005, 5, TO_DATE('2021-09-10', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6006, 6, TO_DATE('2023-05-01', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6007, 7, TO_DATE('2023-12-20', 'YYYY-MM-DD'), 'PayPal');

-- Payment for Guest 0003
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6008, 8, TO_DATE('2021-01-13', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6009, 9, TO_DATE('2024-02-10', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6010, 10, TO_DATE('2021-07-19', 'YYYY-MM-DD'), 'Touch ''n Go');

-- Payment for Guest 0004
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6011, 11, TO_DATE('2024-05-19', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6012, 12, TO_DATE('2022-06-18', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6013, 13, TO_DATE('2024-07-21', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6014, 14, TO_DATE('2023-08-01', 'YYYY-MM-DD'), 'Credit Card');

-- Payment for Guest 0005
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6015, 15, TO_DATE('2021-07-10', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6016, 16, TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6017, 17, TO_DATE('2020-09-19', 'YYYY-MM-DD'), 'PayPal');

-- Payment for Guest 0006
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6018, 18, TO_DATE('2024-05-28', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6019, 19, TO_DATE('2019-11-27', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6020, 20, TO_DATE('2020-01-02', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6021, 21, TO_DATE('2019-12-10', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6022, 22, TO_DATE('2020-03-20', 'YYYY-MM-DD'), 'Bank Transfer');

-- Payment for Guest 0007

INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6023, 23, TO_DATE('2020-11-01', 'YYYY-MM-DD'), 'Credit Card');

-- Payment for Guest 0008
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6024, 24, TO_DATE('2021-07-18', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6025, 25, TO_DATE('2023-08-20', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6026, 26, TO_DATE('2023-09-10', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6027, 27, TO_DATE('2023-10-12', 'YYYY-MM-DD'), 'Touch ''n Go');

-- Payment for Guest 0009
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6028, 28, TO_DATE('2024-06-02', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6029, 29, TO_DATE('2021-06-05', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6030, 30, TO_DATE('2024-02-13', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6031, 31, TO_DATE('2022-09-05', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6032, 32, TO_DATE('2023-11-20', 'YYYY-MM-DD'), 'Bank Transfer');

-- Payment for Guest 0010
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6033, 33, TO_DATE('2023-11-01', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6034, 34, TO_DATE('2023-12-07', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6035, 35, TO_DATE('2024-03-21', 'YYYY-MM-DD'), 'Credit Card');

-- Payment for Guest 0011
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6036, 36, TO_DATE('2021-04-08', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6037, 37, TO_DATE('2024-05-07', 'YYYY-MM-DD'), 'Touch ''n Go');

-- Payment for Guest 0012
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6038, 38, TO_DATE('2019-06-01', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6039, 39, TO_DATE('2020-06-13', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6040, 40, TO_DATE('2021-07-21', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6041, 41, TO_DATE('2023-09-20', 'YYYY-MM-DD'), 'Bank Transfer');

-- Payment for Guest 0013
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6042, 42, TO_DATE('2020-12-12', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6043, 43, TO_DATE('2023-01-21', 'YYYY-MM-DD'), 'Credit Card');

-- Payment for Guest 0014
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6044, 44, TO_DATE('2023-04-10', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6045, 45, TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'PayPal');

-- Payment for Guest 0015
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6046, 46, TO_DATE('2023-01-10', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6047, 47, TO_DATE('2023-08-02', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6048, 48, TO_DATE('2023-04-04', 'YYYY-MM-DD'), 'Bank Transfer');

-- Payment for Guest 0016
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6049, 49, TO_DATE('2024-05-25', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6050, 50, TO_DATE('2023-06-10', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6051, 51, TO_DATE('2023-07-16', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6052, 52, TO_DATE('2023-09-16', 'YYYY-MM-DD'), 'Credit Card');

-- Payment for Guest 0017
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6053, 53, TO_DATE('2022-10-02', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6054, 54, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'PayPal');

-- Payment for Guest 0018
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6055, 55, TO_DATE('2020-12-20', 'YYYY-MM-DD'), 'Bank Transfer');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6056, 56, TO_DATE('2024-05-07', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6057, 57, TO_DATE('2019-05-16', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6058, 58, TO_DATE('2021-06-05', 'YYYY-MM-DD'), 'Touch ''n Go');

-- Payment for Guest 0019
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6059, 59, TO_DATE('2020-06-28', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6060, 60, TO_DATE('2019-10-08', 'YYYY-MM-DD'), 'Touch ''n Go');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6061, 61, TO_DATE('2021-12-19', 'YYYY-MM-DD'), 'Credit Card');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6062, 62, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 'Credit Card');

-- Payment for Guest 0020
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6063, 63, TO_DATE('2023-03-27', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6064, 64, TO_DATE('2023-07-10', 'YYYY-MM-DD'), 'PayPal');
INSERT INTO PAYMENT (PaymentID, BookingID, PaymentDate, PaymentMethod) VALUES (6065, 65, TO_DATE('2022-05-12', 'YYYY-MM-DD'), 'PayPal');

-- Insert records into the FACILITY table (NON-EVENT TABLE)
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5001, 'Swimming Pool', '08:00', '20:00', 'No diving allowed.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5002, 'Gym', '06:00', '22:00', 'No food or drink.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5003, 'Spa', '09:00', '21:00', 'By appointment only.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5004, 'Sauna', '10:00', '20:00', 'Limit of 15 minutes.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5005, 'Conference Room', '08:00', '18:00', 'Reservation required.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5006, 'BBQ Area', '10:00', '22:00', 'Clean up after use.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5007, 'Playground', '07:00', '19:00', 'Supervise children.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5008, 'Tennis Court', '07:00', '22:00', 'Booking necessary.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5009, 'Library', '09:00', '17:00', 'Quiet area, no food.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5010, 'Game Room', '10:00', '22:00', 'No loud noises.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5011, 'Laundry Room', '06:00', '22:00', 'Use at your own risk.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5012, 'Parking Garage', '24/7', '24/7', 'Park only in assigned spots.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5013, 'Jacuzzi', '09:00', '21:00', 'No glass containers.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5014, 'Basketball Court', '07:00', '22:00', 'Shoes required.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5015, 'Rooftop Garden', '08:00', '20:00', 'No smoking.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5016, 'Fishing Pond', '06:00', '18:00', 'Catch and release only.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5017, 'Bar', '17:00', '23:00', 'ID required.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5018, 'Pet Park', '07:00', '19:00', 'Dogs must be leashed.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5019, 'Art Gallery', '10:00', '18:00', 'No flash photography.');
INSERT INTO FACILITY (FacilityID, Name, OpeningHours, ClosingHours, Rules) VALUES (5020, 'Café', '07:00', '19:00', 'No outside food or drink.');

-- Insert records into PropertyFacility table (NON-EVENT TABLE)
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (100, 5001);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (100, 5002);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (200, 5003);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (300, 5005);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (300, 5006);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (400, 5007);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (400, 5008);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (500, 5009);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (500, 5010);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (600, 5011);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (600, 5012);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (700, 5013);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (800, 5015);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (800, 5016);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (900, 5017);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (900, 5018);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1100, 5001);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1100, 5002);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1200, 5004);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1300, 5005);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1300, 5006);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1400, 5007);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1400, 5008);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1500, 5010);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1600, 5011);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1600, 5012);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1700, 5013);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1700, 5014);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1800, 5015);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1900, 5017);
INSERT INTO PropertyFacility (PropertyID, FacilityID) VALUES (1900, 5018);