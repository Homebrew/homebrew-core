class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "bac497857759e991fa4e1638bccf936cb36d10ad79273695a570272cc4891428"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7501cd357dbba8e12e7c90d2fb29fda26bb7277d522238748ef7cc1bf576fb88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d28907449989318328940cf10c77a80db3dc1623a4e1b9b73385f04e6212af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae1ba7f154c556ecf82807fd2fd22f8e0fbd3bba56129451c02c506dc0b04a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbef61f1019163ab48478b4264dd2d5a3d9f3b313b8b8293b97a1ce9496a0c76"
    sha256 cellar: :any,                 arm64_linux:   "3aceb0d5257ad07ef2f5ac54aa5756f86dd0c5ef08d9580be6307feb92fb7583"
    sha256 cellar: :any,                 x86_64_linux:  "ce66a13d493bf370aee5c365be52e5438beed57479e8b2be002709c774fecdc3"
  end

  depends_on "cmake" => :build
  depends_on "abseil" => :no_linkage
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "zstd"

  def install
    # We use the vendored version (1.0.2) of `cityhash` because newer versions
    # break hash compatibility. See:
    #   https://github.com/ClickHouse/clickhouse-cpp/pull/301#issuecomment-1520592157
    rm_r(Dir["contrib/*"] - ["contrib/cityhash"])
    args = %W[
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
      -DWITH_OPENSSL=ON
      -DWITH_SYSTEM_ABSEIL=ON
      -DWITH_SYSTEM_CITYHASH=OFF
      -DWITH_SYSTEM_LZ4=ON
      -DWITH_SYSTEM_ZSTD=ON
    ]
    # Upstream only allows building static libs on macOS
    # See: https://github.com/ClickHouse/clickhouse-cpp/pull/219#issuecomment-1362928064
    args << "-DBUILD_SHARED_LIBS=ON" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"main.cpp").write <<~CPP
      #include <clickhouse/client.h>

      #include <exception>

      #include <cstdio>
      #include <cstdlib>

      int main(int argc, char* argv[])
      {
          int exit_code = EXIT_SUCCESS;

          try
          {
              // Expecting a typical "failed to connect" error.
              clickhouse::Client client(
                clickhouse::ClientOptions()
                .SetHost("example.com")
                .SetSendRetries(1)
                .SetRetryTimeout(std::chrono::seconds(1))
                .SetTcpKeepAliveCount(1)
                .SetTcpKeepAliveInterval(std::chrono::seconds(1))
              );
          }
          catch (const std::exception& ex)
          {
              std::fprintf(stdout, "Exception: %s\\n", ex.what());
              exit_code = EXIT_FAILURE;
          }
          catch (...)
          {
              std::fprintf(stdout, "Exception: unknown\\n");
              exit_code = EXIT_FAILURE;
          }

          return exit_code;
      }
    CPP

    args = %W[
      -std=c++17 -I#{include} -L#{lib} -lclickhouse-cpp-lib
      -L#{formula_opt_lib("openssl@4")} -lcrypto -lssl
      -L#{formula_opt_lib("lz4")} -llz4
      -L#{formula_opt_lib("zstd")} -lzstd
    ]
    args << "-lcityhash" if OS.mac?
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end
