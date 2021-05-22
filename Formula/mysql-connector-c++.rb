class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.25-src.tar.gz"
  sha256 "49f082ed21c04348b7080d505ae0c85fd3bd1156ff511a3b53a97ab026243194"

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "83d780fbc88c50150d3470e3d40984b42d0c6b52206030b7ce74f369e9fa2b9e"
    sha256 cellar: :any, big_sur:       "899bf247d7e908f0d0951911a86e7e2f6fd686621c26f11e01ec8a80ecc10e4a"
    sha256 cellar: :any, catalina:      "47908d7e66f1a9016cf0846475abe6a10844f9552d5c3443cf056c6aad31b235"
    sha256 cellar: :any, mojave:        "3a18a39e4092459d7aacc5e2c23601e0cefb0e9db0ce2ce77490a37ecc48ec5b"
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
