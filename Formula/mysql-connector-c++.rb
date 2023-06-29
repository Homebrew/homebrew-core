class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.33-src.tar.gz"
  sha256 "160cf6881fbde9bd46cd11aaf12930b676bc6e27589ac5c7ba49c196b97e053b"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 1

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d14671c0ceeed3b1177e8dbad360276eb08a2750ffa94bf0d7dfbb3189733205"
    sha256 cellar: :any,                 arm64_monterey: "f7612c7827caaa37ae09993f4471136c6da763709a856de949c163b2f389a811"
    sha256 cellar: :any,                 arm64_big_sur:  "72a939f6154ee70022b3777324ccfbc4f1fd281bc121b3e6fa90dfac63b15541"
    sha256 cellar: :any,                 ventura:        "132e3e95c0691a0b161045eda612a37cdb953bcee7374f260c6312037f1d0190"
    sha256 cellar: :any,                 monterey:       "d1aa618dec90255da12723c50560d6af74e8ab20ebdbbae80a844f326c28c4ad"
    sha256 cellar: :any,                 big_sur:        "6934cc4467099f246653f21f93ba50186655bd8a8d96357225ad5e277b3871fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee4b93dab15311180101f9b729a3e40cabeb2266fc3bdc0ea517e0ffa0fe124"
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
