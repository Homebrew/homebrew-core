class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.28-src.tar.gz"
  sha256 "cb26fe9de05a3b5f1ed22a199429b6791ece18433eb0465e2a73fcf44586420b"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fe3d576cd8487aafb673dccef66b90b1d114f81ed9d33188aafffca58028733c"
    sha256 cellar: :any,                 arm64_big_sur:  "adda7eb72ea92299565a006836f05350f36aaf3280fd3343460a0c97911d84d9"
    sha256 cellar: :any,                 monterey:       "dc58916ed5dd075ba410f49d4b5e173207e3368ef8d14b0aa3198f070a490515"
    sha256 cellar: :any,                 big_sur:        "1d4dbdfe1b037a04d45ca6f2f9d1fa71c24ec4c6b760133344f736f1da87016f"
    sha256 cellar: :any,                 catalina:       "3939ecdcf8ecdfd5fab7f8a2a1480e36b99632c4e66c10398aba1240f8a89527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b8d3abc117a047e9396fd58603770f3d21c6a23daf486ff521ff67c03b1779"
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
