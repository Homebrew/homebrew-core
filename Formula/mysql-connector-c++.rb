class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.26-src.tar.gz"
  sha256 "50f881e0a46ec87dd789ce68edbbe076998d6c3f8c1ea40cbfbf5e441b710de2"

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c2724fb302717971198fbe9ee88eab11b567245a38930fa09e850d33e51ff52a"
    sha256 cellar: :any,                 big_sur:       "4b5b3f5771d16b17f1ad25516e74d896ae8457ca4d881a3be6d462e1d080a70b"
    sha256 cellar: :any,                 catalina:      "f275aee357097980fbfb2a3d0cc85a18e351485ec379e5114d26ed11e9651f2b"
    sha256 cellar: :any,                 mojave:        "9a3ca934438ade3efcd8c07a18aa042c5a3139bf73fac933ec26256ba568a769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8908fc1414386886657230d08f5bb7cf45eb47695e67c6aec7b04466e234f813"
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
