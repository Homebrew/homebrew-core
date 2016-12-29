class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-1.1.8.tar.gz"
  sha256 "85ff10bd056128562f92b440eb27766cfcd558b474bfddc1153f7dd8feb5f963"

  bottle do
    cellar :any
    rebuild 1
    sha256 "115d7b4a6a085f11f5161a226c66d36f1bfe53740a5872db0221d7e921197c56" => :sierra
    sha256 "099f5becae09aea2402af65179ae0a9e59824f7e0c819623e6ceed2109d5653e" => :el_capitan
    sha256 "4a3c1052035254d8a1ff9991909eb7249aea0d8723e44448a3fdd7417f5d204f" => :yosemite
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
