class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.32-src.tar.gz"
  sha256 "fbdb7f214427632f423e84ba7594be1f9205eac8128c6b1857203b2f5455cef3"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9710648b67da44ee1d92dfa2ac023b66c7e193b1deb68bc618124a6afa23f97b"
    sha256 cellar: :any,                 arm64_monterey: "678881af35d1147a5c0b630930f2994af40419420dd84ac1adeaa5ba12d7446f"
    sha256 cellar: :any,                 arm64_big_sur:  "f8df7b38314468440fabc7661fc44df6ff6134617581da6c0351693d48052feb"
    sha256 cellar: :any,                 ventura:        "4553fed15ffb695ee07243ffa9ea8a25ebfca275ce03d25039b6a20b8ded0700"
    sha256 cellar: :any,                 monterey:       "ada40ba2c5a2c4abedfe348ac3a17d269c3b2bb25d91773a5a3117cb2767021b"
    sha256 cellar: :any,                 big_sur:        "de8c2d95a26c4ee682d5198a9ca755f28ad697b85980404615ccca04a831329d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a085d1cfbe804db4c89f3a93c69acbd73f1ead03c44747ad7847d63582c1302"
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
