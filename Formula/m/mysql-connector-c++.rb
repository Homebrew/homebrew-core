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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "25a5e5655a23a9b4ca1c8942e51f7d48b526666c14ba27911a7f568692f853a6"
    sha256 cellar: :any,                 arm64_sequoia: "276ae190eae1888565b428290ab05f882f21b9aaa23ce0ec75d075621b22a639"
    sha256 cellar: :any,                 arm64_sonoma:  "56c758e115c4b0df9d79ca51f1100f9b1b8dd572ebb4352acb6f470c8e06c6d3"
    sha256 cellar: :any,                 sonoma:        "e4f93817027db4e59c1a48323f74f41c3d3624fdbf1ceb49b3549ad74531c503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f03df5bf0630b4819866f36a6d1cd811f7a72f465bba1a8a361ccc5e5e7fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414bfc26006113beacde84911a23ebf239871df6df0ca8050c36382cb2b3d46f"
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
