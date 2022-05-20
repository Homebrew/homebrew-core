class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.29-src.tar.gz"
  sha256 "9a6236a28bca33ae951d8ccaabb8ff51a188863e8599f9096f4ae0a1da19f87f"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8d44b981fafe057bd1b55ab1c2efe186859613540f67acd5cc64dc6ca4a0765c"
    sha256 cellar: :any,                 arm64_big_sur:  "7f2513672ff63de832c621dcefb345e80e3f2259f4d2e4dfc401753bd09d83da"
    sha256 cellar: :any,                 monterey:       "960e38066622667cd4668eccad4a780f06da9eb114a460d31f8e2236fcf09456"
    sha256 cellar: :any,                 big_sur:        "8c9034de4514fe997aab920f512b0fec0ae8861f604d0ed7b8924b4e7eb9195a"
    sha256 cellar: :any,                 catalina:       "4744e3345c3b18f8265d68e32a3de1df41cc88e1631ea3caa6dec2fd5b70f8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8ad4bb4424500ef39f08b7abe150bf9ec143480b6f2729f4a1fa0a4593a12f"
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
