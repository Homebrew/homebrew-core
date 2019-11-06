class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.18-src.tar.gz"
  sha256 "63b20e446c0aadeddbbc5cef36db8222d602793e6f1e6de511bdf7bcb2181f86"

  bottle do
    cellar :any
    sha256 "d2f10b3cf8427392875384a867ec170eebe6fbea36006f3d3e74a5f5a62120d9" => :catalina
    sha256 "88d27cf897808cf89158469faf309c1771522e0e6e07632c46a38c9c84873dad" => :mojave
    sha256 "cf8f23c86220e60cde4efab54cfc046d3895c517504f4b76d6f371a1a66d997f" => :high_sierra
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
