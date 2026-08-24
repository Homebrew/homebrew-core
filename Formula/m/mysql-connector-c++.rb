class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://github.com/mysql/mysql-connector-cpp"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-26.7.0-src.tar.gz"
  sha256 "5b84d0b662ad7d5c0e3ac2c6d9cc708065941efe365097fa96bde24b1606b319"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "629d29b77b00791626e1e962d2086d6870b4c513b8a455d63524e3587564eac8"
    sha256 cellar: :any, arm64_sequoia: "c3e1202ff7f3781c250a710c2b089715ae611cc618e35a9ef8c891612dcad498"
    sha256 cellar: :any, arm64_sonoma:  "f1ea4c69d8b8256e208ba38020780d3da82e34e3f1a3b77422fc1ddb9bee76b7"
    sha256 cellar: :any, sonoma:        "42766f509ce4a339b53f71f867ce9f234d06048443572bd86811e6998ad45b53"
    sha256 cellar: :any, arm64_linux:   "a6ca7ff0f18824da9673cfd440679f7e5a3704b7c74b427069eff69e269b405f"
    sha256 cellar: :any, x86_64_linux:  "1551e59b6282a42e5fb0f9abebb3e4293700cf351ba9a4a8976ff7ca41316d9f"
  end

  depends_on "cmake" => :build
  depends_on "rapidjson" => :build
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
