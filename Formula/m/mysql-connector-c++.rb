class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://github.com/mysql/mysql-connector-cpp"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-9.3.0-src.tar.gz"
  sha256 "268a6f7f4a6cb59f53dde59623be1559f913a29ec1de81bf0ffccbf780d1b416"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9fb2e53db8e66e690169f2f2de4b29ff2075256e9c6a3e6b6b5b726eed64987"
    sha256 cellar: :any,                 arm64_sonoma:  "ce2e5744046cb1337129d204a5444dd35023a80052caf55da8c49fa7987984e4"
    sha256 cellar: :any,                 arm64_ventura: "d85ecee591ca559101de9fd260f29577b22ece7f9764003b4f70aaaa221eda1f"
    sha256 cellar: :any,                 sonoma:        "6b7582900baea050d27da4e7d11c664e6db4fa663b83d0f859b3bd38284aca68"
    sha256 cellar: :any,                 ventura:       "3813e6d044a752fb35926e88eb4fcb15a7ef17ceb0255aa384f5e8f1ba576f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "695e5c79c45aff0ea0f2a7ad5f9d49a6bb8290bacef69e3588e36bf2f8baf4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57bf19bc54526110f1e05873cf1286d9e90195abc44deb45c648a4de80f7c3a2"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zlib"
  depends_on "zstd"

  def install
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
