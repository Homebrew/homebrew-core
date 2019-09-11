class MysqlConnectorCxxAT11 < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-1.1.12.tar.gz"
  sha256 "ffc4604064c8861e2c2ece80dc4830ec1e8816de4d54f0d3ca0c451234068751"

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
