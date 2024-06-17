class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.3.0-src.tar.gz"
  sha256 "a17bf1fad12b1ab17f5f6c7766289fb87200e919453234c3ec1664d7734be8f8"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c56f0934396d5ba2fc6cd1215ce6eb1dcac462f3cc94e814c24c447d6383d208"
    sha256 cellar: :any,                 arm64_ventura:  "516568096d1d86555dc3f852f4bcb3ee29f823bce2f84f5b793c12497a5055f0"
    sha256 cellar: :any,                 arm64_monterey: "59ab74403bb464e4bce2f021ac55cd15f20b36a61392113c328643e744889e15"
    sha256 cellar: :any,                 sonoma:         "11477c00a9adb60a2ea3dc33567a6fb8fc46d370ffb39062aa745d92db31ff6e"
    sha256 cellar: :any,                 ventura:        "33c6128f3bce09611f5e8b5305c0e482ab333f795963eabb289e4235257a1c48"
    sha256 cellar: :any,                 monterey:       "c48c5b626bc825938b0678136f79bf4f16903830317435481c56385f2085472c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8b96d13b8c14d3998a78f39c90021a78998b5a055753ae4efc3b52a3e92744"
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
