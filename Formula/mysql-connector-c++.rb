class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.19-src.tar.gz"
  sha256 "7c3bd74ce64a9300e7d481b76b388ad95017a52480c698b755579aec62d4a21e"

  bottle do
    cellar :any
    sha256 "96a111e160d5679d219db4a6a6a8814c639fa7fdf90ecd3e4e5a5d9f2a1adbf8" => :catalina
    sha256 "593b8b076c869e9e7dac19950656d338ee54db5b364186d949ae6c1b7c63ebcb" => :mojave
    sha256 "c5b39ffed5a049ad6ab5d3e0ab201e5422840c48e648dc74ff57ecbb02702145" => :high_sierra
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
