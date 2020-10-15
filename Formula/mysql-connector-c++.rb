class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.21-src.tar.gz"
  sha256 "70e11c81ee6f482f4d2954a0aa5c43ab35bb6b2a0f0cadcd37e246950201e423"

  livecheck do
    url :homepage
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+.\d+.\d+)-/i)
  end

  bottle do
    cellar :any
    sha256 "de70755aba3f996f670ebfb1a87a0c8e6664e7b43f498b3a6ef142ff96e1f64f" => :catalina
    sha256 "d674541be036abf14122f6df709ec1cd4aac4e87bcb4265f68f1433ef56eeb46" => :mojave
    sha256 "4989e5985a9c5c26f9d7878cc4aa683a791c889dc7a4d6e5b9ef323d0a84defd" => :high_sierra
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
