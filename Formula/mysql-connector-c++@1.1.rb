class MysqlConnectorCxxAT11 < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-1.1.13.tar.gz"
  sha256 "332c87330ab167c17606b95d27af110c3f8f228658e8ba0d1f6e5f0a0acf3b41"
  revision 1

  bottle do
    cellar :any
    sha256 "08bf6fb8a787b7b007717ce1099121239c44e02a4cce5d0c7c5dcb82835d3447" => :catalina
    sha256 "759c0753dba575dbe1d13eb9a8a6658fb9ed93a840cc1147eb36f8bbcc98f3ea" => :mojave
    sha256 "57d1006de8cc2f45f4860b1a4726cf1426f665810f6167dee1c77ba2f006a471" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "mysql-client"
  depends_on "openssl@1.1"

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
    system ENV.cxx, "test.cpp", "-I#{Formula["mysql-client"].opt_include}",
                    "-I#{include}", "-L#{lib}", "-lmysqlcppconn", "-o", "test"
    system "./test"
  end
end
