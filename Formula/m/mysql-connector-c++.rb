class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://github.com/mysql/mysql-connector-cpp"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-9.4.0-src.tar.gz"
  sha256 "36a7c93d4a10d1da2a2e66367559d91741aa0f0362bc0ae943171cf1771f6615"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "255ec051bd854153608e0e25da87160937c521ae89153f42e06fdf9a0308d710"
    sha256 cellar: :any,                 arm64_sequoia: "cf99e65f74904960f28ee583f0b94b515d77dbe7bbcebde9978dace287343808"
    sha256 cellar: :any,                 arm64_sonoma:  "03419d53245935f10ec1a09b572b743d72296621fc272df5243f6226559e9d0e"
    sha256 cellar: :any,                 arm64_ventura: "1fc551617b7ac4ea82019d7bccd26a7eb7ddb08d2416eb2f1a7c7afd0ce7bc8c"
    sha256 cellar: :any,                 sonoma:        "523c8d5126929f65d7b6f9ba3d4d031b81bbd2ac6b8bf2b81cf50dd9dc3fabe0"
    sha256 cellar: :any,                 ventura:       "36f03197c465f7b253533db0c9b13ae421ac0e121287bf69cfa4263a02cf5f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cc966ac69e402ede9f330d3ec27f70e486fe284f99f807e26c538ffa25a9021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4201f9b7cb6354e37047633ea32a7d4ccb858f464dee3a0e6f5c56b0542932e5"
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
