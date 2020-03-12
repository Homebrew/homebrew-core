class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.19-src.tar.gz"
  sha256 "7c3bd74ce64a9300e7d481b76b388ad95017a52480c698b755579aec62d4a21e"

  bottle do
    cellar :any
    sha256 "fbcc82091507f2c2afa293d37fd4555bad913658bc45cbc918eefdec51fbd851" => :catalina
    sha256 "dc606f49cbc462260d7b6393516ca83fbc2ef5c27ef0c03eb07e1d1b87ebb410" => :mojave
    sha256 "f40d21c435aa17de9c63d4759b40cc36fb7fcdd371f01f23f6755aebec6d956b" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "mysql-client"
  depends_on "openssl@1.1"

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
