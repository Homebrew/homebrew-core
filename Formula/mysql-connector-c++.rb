class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.17-src.tar.gz"
  sha256 "69de69f373a7c5ddf291c15c52af83d634e0b900cb1204eddb3834836afe7dbe"
  revision 1

  bottle do
    cellar :any
    sha256 "2a77531d227a134ad59877a2ac8901970f364b27d9afeb6d0619a7aebc5cb29d" => :catalina
    sha256 "46b923ef7c8e958719228f76134a6205d3ad597d0f4d85dc6842fb1f2ed14d40" => :mojave
    sha256 "0eb28a81c15aa1b5d860a9655f9b99b8dfb2733b3d3e9d0f1c155e85eb916b0c" => :high_sierra
    sha256 "76973ed4a3a1f6f858696fd919ab60d188e0f91daac9e4899df3bbfabbae4620" => :sierra
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
