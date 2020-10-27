class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.22-src.tar.gz"
  sha256 "74ff7662444dc214ec737baaf48a7f6c44f6e999549bf6930c2a97af24332b47"

  livecheck do
    url :homepage
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+.\d+.\d+)-/i)
  end

  bottle do
    cellar :any
    sha256 "a7ce662aff4a29d35a46486d661bbf1b0149079455a760ea829810ca92423b02" => :catalina
    sha256 "5ae4ddc27990c9ef8019a4668a150af3671ce41a066d7917eb026b224bba54fb" => :mojave
    sha256 "cbb2bfbf652d2d3d55e67de4b3b2af131dc76b520e9eddb3ce4b26c722b1c9ac" => :high_sierra
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
