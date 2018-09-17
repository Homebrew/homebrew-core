class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.9.tar.gz"
  sha256 "3e31847a69a4e5c113b7c483731317ec4533858e3195d3a85026a0e2f509d2e4"
  revision 2

  bottle do
    cellar :any
    sha256 "4fb493a07a4f86fa178bb4b879048395774d9b8787575dfd0b582420a3c44960" => :mojave
    sha256 "03e1e94df2c84a0540e306e6b9f1a121957eb18d7571be8b503c792f32def44f" => :high_sierra
    sha256 "251a3651e8d6d0d38488e5b18c25ff29b41b3caf0103ae578e1cc31625b9b947" => :sierra
    sha256 "bc45340a1bc8e4484cf8e06c25bc475cb455ed12d79c6265d47ecb724ee97c3d" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "mysql-client"
  depends_on "openssl"

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
                    "-L#{lib}", "-lmysqlcppconn", "-o", "test"
    system "./test"
  end
end
