class MysqlConnectorCxxAT11 < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-1.1.13.tar.gz"
  sha256 "332c87330ab167c17606b95d27af110c3f8f228658e8ba0d1f6e5f0a0acf3b41"
  revision 1

  bottle do
    cellar :any
    sha256 "1b0c4d5c80e79bfc4a0afe48e3873a8ec68559e40cf15816afce4889f053e049" => :catalina
    sha256 "7a5921a21cc044dbab44039e7ca0b39c60746460f4362b93dc15f07c13c95c20" => :mojave
    sha256 "9e429fbb0b1295dd185625cb5a792923aa3b7aea8ebebdf50da7dce134c481da" => :high_sierra
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
