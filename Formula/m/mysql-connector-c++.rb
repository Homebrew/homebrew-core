class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://github.com/mysql/mysql-connector-cpp"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-26.10.0-src.tar.gz"
  sha256 "25d83a76164da29592b4e029c6e771cd05139453be2f8fc206cc7c73d19fa9b2"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src",
        user_agent: :browser
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e0e6658995b94c714164677ea4f698d02b0234b5623ba7e33ae65921c4f8f6e"
    sha256 cellar: :any, arm64_tahoe:       "17bffea0ae2c87a8ac512f377d795c13272cf3c0c630fee44f03e880bbd42952"
    sha256 cellar: :any, arm64_sequoia:     "f8a0f6c03be9d1aa6da11bc1e3a8810cbc6ace9e52501c9062288981b46913bb"
    sha256 cellar: :any, arm64_linux:       "cd8270917b88028c42c66fb7d9e6f836685f1bb2c1ca3b2bd02fc1737d4b1d2f"
    sha256 cellar: :any, x86_64_linux:      "21766b9eeae2f3b0518fe70991cf9aa549ffdeb1e79e7e6667f1147240490422"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

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
