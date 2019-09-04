class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.17-src.tar.gz"
  sha256 "69de69f373a7c5ddf291c15c52af83d634e0b900cb1204eddb3834836afe7dbe"
  revision 1

  bottle do
    cellar :any
    sha256 "5fdaa61ec06aad39c52b1638baf5c062a1ae9b1ae86726c3f3421c19ab1b9ef6" => :mojave
    sha256 "72940532ebac56878aed409ed1d9de49e581ce4f322610d29a24980ce1f0c45f" => :high_sierra
    sha256 "826e77eaf68079bcee9c6ad167276f0c8dcbca4bd488fca56ed84dc35029593f" => :sierra
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
