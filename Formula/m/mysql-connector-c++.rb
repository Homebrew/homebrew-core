class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-9.1.0-src.tar.gz"
  sha256 "70fb6ca28ac154a5784090b3d8cc4f91636c208cf07c0000e3d22f72b557be13"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c2b2490600fdbe3f9c0d8905b865226c43b1d18acde422368b60ac78cdb2d824"
    sha256 cellar: :any,                 arm64_sonoma:  "abbe09e0b54dff9192c08d7590bb5471fcfe100cfddbb88da19c5fad07a8f53f"
    sha256 cellar: :any,                 arm64_ventura: "74268250b16280da66df74087862538541b0743f6bf072e0dd73fa7ddb9cb68d"
    sha256 cellar: :any,                 sonoma:        "b7f37cc9be177add80233edced3ca587144ecee5efa796dd05f6f024c5d43154"
    sha256 cellar: :any,                 ventura:       "a66e65ee7ba2aff015c4e477b4041740916da4f8af70662f9621c53136f341dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43f4750299363720f98a8bb94292922722f2c039ba05b704de9b1b4f5dbd7e5"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zlib"
  depends_on "zstd"

  def install
    args = %w[lz4 rapidjson zlib zstd].map do |libname|
      rm_r(buildpath/"cdk/extra"/libname)
      "-DWITH_#{libname.upcase}=system"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lmysqlcppconnx", "-o", "test"
    output = shell_output("./test")
    assert_match "Connection refused", output
  end
end
