class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.33-src.tar.gz"
  sha256 "160cf6881fbde9bd46cd11aaf12930b676bc6e27589ac5c7ba49c196b97e053b"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a257bf5c7c73420ff596e1ffdfdcdefa93258c47a30868db9959615a3f25cbf"
    sha256 cellar: :any,                 arm64_monterey: "5362e32cc2d03b920cbe4962a8062878f89b04c1d8bf8def155080158023ef9b"
    sha256 cellar: :any,                 arm64_big_sur:  "4ed908defe763907f2480b250fdf8ac3fa55608681a21719e1ad81a1252704bb"
    sha256 cellar: :any,                 ventura:        "5b56cc5526d3a7318d8e4585a909ebda9d31cd53c81c4071fc0dc4a1e734f5a5"
    sha256 cellar: :any,                 monterey:       "ffc6a362bafca5f0a019fd342fdae3600356366ba04417b2ce74982ee6049b43"
    sha256 cellar: :any,                 big_sur:        "a45e548dbab4734bfd6574e9b62e27bd2420830425441e46289d4a9335019d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eef34c090c4f3a312f11e8fecfabefb74d05db8e0ac9c781766274f91253c57"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DINSTALL_LIB_DIR=lib", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
