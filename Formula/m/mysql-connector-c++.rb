class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.1.0-src.tar.gz"
  sha256 "2ee3c7d0d031ce581deeed747d9561d140172373592bed5d0630a790e6053dc1"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e51ebf73ecfd495d12fd33fa0e37f54842bf49d2879dcdb87fc25c7903e8ebd6"
    sha256 cellar: :any,                 arm64_ventura:  "a6a585787375a14f376f0aa07c67c57095cdbc272fe92983b71bb019a8b02a5b"
    sha256 cellar: :any,                 arm64_monterey: "7af3494b95ec4977232119a354da6dc39fe30450fde4d148a8e4788c22e5d406"
    sha256 cellar: :any,                 arm64_big_sur:  "4537b541e9cbdbe02df3e3d2d5b11d38ac8b30f47eb9ca0d967ede1d1c514c8a"
    sha256 cellar: :any,                 sonoma:         "aa2c7d45d4ef2d9c7f2a43ac5fc62732cefc4940a39aabd65db47b0ef1c55451"
    sha256 cellar: :any,                 ventura:        "e96cd1398dc1d1643962c9ef91537bafe111d8989014b8f89be7ffa87120448b"
    sha256 cellar: :any,                 monterey:       "c5c70d0d3dc446f5d0a1a3c0519cb25f186bf387ad30ff30dd73f18a51478a8f"
    sha256 cellar: :any,                 big_sur:        "f6933eacd554bf46f8ec0c2852cb9db770d7ddaa9098c7ecd235763eb507af3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b246e5382a67b75ef223b4fb9f199490930e2184c4f0d6a67c53da9e759f3b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "mysql-client"
  depends_on "openssl@3"

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
