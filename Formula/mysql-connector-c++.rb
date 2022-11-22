class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.30-src.tar.gz"
  sha256 "5b2ceebe3986fe6d6b0c6f29b6912cb3a1cabf998d2c4c4127452768de75ab0b"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cdfdaf9635365b9b82ed2b97b35e4feaa19b9dc57de194b25b803dfbd2fe03fc"
    sha256 cellar: :any,                 arm64_monterey: "681fac456c8676f2cd56dd849cb26c12d230f24e42f3b84f52090594fddd9b5e"
    sha256 cellar: :any,                 arm64_big_sur:  "faa9e4a14708b37e160b71e6ca3d801e8f539087a5129b6cf80bccb7e82e0ed4"
    sha256 cellar: :any,                 ventura:        "137a609f49adb86329d64874300e2bb855bb44ece1febae4900f16a7c039b50c"
    sha256 cellar: :any,                 monterey:       "bf509a6346328acebe632c087ccf64d45d9aeeaee2a62e919e2cc0d547cff928"
    sha256 cellar: :any,                 big_sur:        "177987159c619258613b2defb87f1ad686cea87c70c967ad0c80fb562fb2d659"
    sha256 cellar: :any,                 catalina:       "71ae5ab9dafca521b0232834702259947cab9677d7df611690ed4bcf6bd61a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e8577785defea700cd26ba07923c34703e5e4dbd8a29c571db04a6dc2eeaefa"
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
