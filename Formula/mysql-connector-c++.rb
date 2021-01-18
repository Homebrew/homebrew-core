class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.23-src.tar.gz"
  sha256 "9af06495a6a080fed62da70978f1cb0c66f058edd5ea9eda9345a64bf8ec688f"

  livecheck do
    url :homepage
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+.\d+.\d+)-/i)
  end

  bottle do
    cellar :any
    sha256 "90e116fbf60b03abb2dc84296879e60485d40e6296966214406a8ce5a1702990" => :big_sur
    sha256 "306284af196c840d9c523d22a36e9fe29037ace2c60daa0a34a71e0354c281bb" => :arm64_big_sur
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
