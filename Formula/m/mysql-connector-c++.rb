class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://github.com/mysql/mysql-connector-cpp"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-9.5.0-src.tar.gz"
  sha256 "386006a7c2deeecfd4d198315a474a1981784f8310b40d5b442ed8dbf0412a11"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a78bf07f08472b0892d3b03114998331eb07e392068a6ac9da322e85bb2e40d"
    sha256 cellar: :any,                 arm64_sequoia: "4e341ecfaaf3c2961a109671e9c722ff04d71a5378190ec56e9592cbd75dfbe6"
    sha256 cellar: :any,                 arm64_sonoma:  "a892e2a9077670e75699f36d6b3e9733139addadd58576eb215865b4eed0fb4e"
    sha256 cellar: :any,                 sonoma:        "2cfc7fc6f303d0a3a7faf6f1dcb940f2f29493735d8ad6097ba23e60d8a94a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1192115c0ce239f289f0bbe1949fc6c8154537840afecf37292ea74534a5dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14ca0f1b8de286e833098df920db40f47a5fb9cda0c6e866d9f8500b38fc02b"
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
