class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://github.com/mysql/mysql-connector-cpp"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-9.6.0-src.tar.gz"
  sha256 "b25a9a139855da9713c863b5a64c7f10c52eded76b2c04a2fb2deb9aab456b3d"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85b33ab13724c520b2e241bf9aa0e56f879a3193c9f6c79d713db38cabd6c739"
    sha256 cellar: :any,                 arm64_sequoia: "3bf252190f11a80e20ef18227f1e4543d1aee5ddf0eebb04aab0b3f972651b0f"
    sha256 cellar: :any,                 arm64_sonoma:  "b265e7438cae35b9db981b4b1118393d53d193767d8cbc0a1956e8526d269748"
    sha256 cellar: :any,                 sonoma:        "9cacb7778940c1334fde91c6fd687b33079124a87ec67c38cce336e82717e5bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f00730d63bad1ca79b7d25b0ff268555e0c6377bea52eefb1dafc44dd17537f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7596409d95470a6887c2fb465d79fa04a3b429ae5436ac04129c00f3065dd7"
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
