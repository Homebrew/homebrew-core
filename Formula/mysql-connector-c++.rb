class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.17-src.tar.gz"
  sha256 "69de69f373a7c5ddf291c15c52af83d634e0b900cb1204eddb3834836afe7dbe"

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
    system "cmake", ".", *std_cmake_args,
                    "-DINSTALL_LIB_DIR=lib"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <mysqlx/xdevapi.h>
      int main(void)
      try {
        ::mysqlx::Session sess("mysqlx://root@127.0.0.1");
        return 1;
      }
      catch (const mysqlx::Error &err)
      {
        ::std::cout <<"ERROR: " << err << ::std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lmysqlcppconn8", "-o", "test"
    output = shell_output("./test")
    assert_match "Connection refused", output
  end
end
