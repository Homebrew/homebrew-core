class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.9.tar.gz"
  sha256 "3e31847a69a4e5c113b7c483731317ec4533858e3195d3a85026a0e2f509d2e4"

  bottle do
    cellar :any
    sha256 "292c972e2c6bdcc5d0503e0dd4dcc86de92c37f77a6838624533f08783ed507b" => :sierra
    sha256 "8cc493b9ed6ec08f68eb5573d439e61849a173c63a552b3c45188da2190ea8fe" => :el_capitan
    sha256 "46d52addb5a73b6cca32b2870df1c16e2d503201518e7c3a09cc4263ea8d8282" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on :mysql

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
