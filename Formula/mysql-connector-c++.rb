class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.9.tar.gz"
  sha256 "3e31847a69a4e5c113b7c483731317ec4533858e3195d3a85026a0e2f509d2e4"
  revision 1

  bottle do
    cellar :any
    sha256 "6c70466e62e77f91a8f3d8e8d824941740af1d00ae5903f2f5267a99eec65f63" => :high_sierra
    sha256 "1ed6ca22cd4a44056080eb829eeda0acd781f2e83d931ba7482c96b78e7863d6" => :sierra
    sha256 "2c6358f7a032c66a18ed1f7dc87ae1b409ae61c689ccb4961afe1fdf97f11103" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "mysql"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cppconn/driver.h>
      int main(void) {
        try {
          sql::Driver *driver = get_driver_instance();
        } catch (sql::SQLException &e) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", `mysql_config --include`.chomp, "-L#{lib}", "-lmysqlcppconn", "-o", "test"
    system "./test"
  end
end
