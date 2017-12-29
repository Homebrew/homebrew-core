class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.9.tar.gz"
  sha256 "3e31847a69a4e5c113b7c483731317ec4533858e3195d3a85026a0e2f509d2e4"
  revision 1

  bottle do
    cellar :any
    sha256 "b21b0c06d48189c5cee017f5bcab7c47813d7d2d8af1d236d64615f18733d043" => :high_sierra
    sha256 "827c6bbf6a320ed506cd4a66a6c20b1f73830c286dba3673610b458f596c0a89" => :sierra
    sha256 "d78c5b2b2fc7df740376901238fac04f2fef0ef731ae9209aa9edc46cb98b2b6" => :el_capitan
    sha256 "7dc67ecd0f99cb8fcc8ddb1620aeef1be9f6c0d02818e12854c2da32fdbda545" => :yosemite
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
