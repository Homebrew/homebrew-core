class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://dev.mysql.com/downloads/connector/cpp/"
  url "https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-9.2.0-src.tar.gz"
  sha256 "249eac2c77f2e4780e0d61b1c3f671ac93cc6e37eee7c9cb81655930e3a38435"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1294550241b2cc6ccff3782a70408dcd6dfa39f354f9b0a41ffcc68caf7c093"
    sha256 cellar: :any,                 arm64_sonoma:  "c4bc88549978f21cf52a143a389e982009ef61ae6a9eec6604cb0aac30e2a52d"
    sha256 cellar: :any,                 arm64_ventura: "8b3803e560a68274050bcec0a6fddd07456f5728ba702a3e270f6d63dce6381a"
    sha256 cellar: :any,                 sonoma:        "9b4da7849dd498166e14f2d3441b6be67d9e156a3870496db51723625720d368"
    sha256 cellar: :any,                 ventura:       "74edf08d8a04e56c4a0b9fae3206c2d68254adde919cdd5d2c188933cede1e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63877e2393a6e26f83636ce0f7962bdf0a6446acff8082b61ec283fcbd59d584"
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
