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
    sha256 cellar: :any, arm64_big_sur: "da7e6c838d9544e91cad96f5617fa23de2e4f840c141aee312e5211324aa58ee"
    sha256 cellar: :any, big_sur:       "f59f257af671acd600a06866dd58bafdea6713e4302f927e55c03420654936a1"
    sha256 cellar: :any, catalina:      "db1c0ddf7b343b3e078d01356d0e5184ba423dc8400746dfb52df85c07c3210c"
    sha256 cellar: :any, mojave:        "46abfd0b0d36f325ca400272b2c331dc1c07581b8dcb1818aa9def027b417a52"
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
