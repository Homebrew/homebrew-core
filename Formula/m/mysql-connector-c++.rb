class MysqlConnectorCxx < Formula
  desc "MySQL database connector for C++ applications"
  homepage "https://github.com/mysql/mysql-connector-cpp"
  url "https://cdn.mysql.com/Downloads/Connector-C++/mysql-connector-c++-9.7.0-src.tar.gz"
  sha256 "9a3dd4fe441a8191f761192ecdc717c18a58a1cbb6e39623debb7196c3075b0e"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/connector/cpp/?tpl=files&os=src"
    regex(/href=.*?mysql-connector-c%2B%2B[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c34a38e56f88a827a0cb055f1ebb7eef5c40d023939263b3d01925ea3fa2dfd7"
    sha256 cellar: :any,                 arm64_sequoia: "918d30529748406b9c8dc644ebde019254e20831c497c9aca189285d6b7a0715"
    sha256 cellar: :any,                 arm64_sonoma:  "b286bbb2e65e9721c07f3cf5cd3aa4c75d098243f8061daae02796fe12ad9637"
    sha256 cellar: :any,                 sonoma:        "429f3910a8be9342d72e5dc636a08634bbfbeebf1a457bec1bd37ba5492b7809"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "856d401321de0183a238b1e15c1553ec54a8bfb787412cd36771cab53fa0c910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "859e9cdcba99f01d1a7e1296ad8a8518a2523734e28efb894ee701cc89cd42f6"
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
