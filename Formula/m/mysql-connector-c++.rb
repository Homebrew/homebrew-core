class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-9.0.0-src.tar.gz"
  sha256 "ed711b4f7b1ffdfc9a76048e195aff287e2d15dddebe0bca851b09e141422b30"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "50552a72448bc5c7bfa87c4f1cbc487964d41c125fa6f21ccee7ec7dc30f4ad4"
    sha256 cellar: :any,                 arm64_sonoma:   "194472846f7a30827dc1ce8a096bf8992921518f44cb9612755bf6a2b2dfaa4d"
    sha256 cellar: :any,                 arm64_ventura:  "9ed7b1655aa310c02e2de3f5e13ca793061fb9ea4bcaed9390e60393797c90b7"
    sha256 cellar: :any,                 arm64_monterey: "9d156aca528c8bfbc3ab7efd746fc1f88f4be17ee59b47d2171ed15765aac192"
    sha256 cellar: :any,                 sonoma:         "be2ef544d3ed696df68265af2b48912588be5594197bcba7e293d6e71b9e0e44"
    sha256 cellar: :any,                 ventura:        "95d4c09ec9e0a02e612848b4e63dc1e33cc2e3e656b0644fdf6f3a4ebeddb8a2"
    sha256 cellar: :any,                 monterey:       "e40f820b8ce1d46f257ed98006474b20c571c2f25431bbda1a1bde30d1766a93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aad48ad2b6b9a0624aa16f28190f3f2a58b704da6a1f795e9529b8e0bc48acf"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "zlib"
  depends_on "zstd"

  def install
    args = []
    %w[lz4 protobuf rapidjson zlib zstd].each do |libname|
      args << "-DWITH_#{libname.upcase}=system"
      rm_r buildpath/"cdk/extra"/libname
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
                    "-L#{lib}", "-lmysqlcppconnx", "-o", "test"
    output = shell_output("./test")
    assert_match "Connection refused", output
  end
end
