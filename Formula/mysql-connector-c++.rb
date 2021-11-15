class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.27-src.tar.gz"
  sha256 "5886698fc682a5e8740822ed9b461bc51b60cf9cbadf4e1c7febe59584b2bfb7"

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a4cc9b1f8b9d72667a52d118f9fcdfbac27e82cd74e0f12339f8dfe9401051fc"
    sha256 cellar: :any,                 big_sur:       "72b1c4ed0b90d576e917b98268da4ab5b94843784049e5155c30a3f1cbbb0733"
    sha256 cellar: :any,                 catalina:      "18bf7a692f7b65626ef3fc2e0fd2ca7f9c3e62484e553941f94f386d71c2f599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c4829d44958cf8560c8e112d9d25ce27b8cee81fb4c289e9fdab53334d15cdd"
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
