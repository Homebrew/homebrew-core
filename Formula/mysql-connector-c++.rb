class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.21-src.tar.gz"
  sha256 "70e11c81ee6f482f4d2954a0aa5c43ab35bb6b2a0f0cadcd37e246950201e423"

  bottle do
    cellar :any
    sha256 "d135296e51b3c7b0eb1a4735250fae125d08ee7367107b9fc71ec43810b009b7" => :catalina
    sha256 "02a6351ad7a7be72463d65ead3b4fe23ad8322ca46a8516fefb7054cadddf29a" => :mojave
    sha256 "093917f65031b2e8a0998b54854976bd5c7ae26ec0a63cfcf48a4906135756e2" => :high_sierra
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
