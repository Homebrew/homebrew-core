class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "bac497857759e991fa4e1638bccf936cb36d10ad79273695a570272cc4891428"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc59c8e3812ac0243f69277819fb097c4b94edff75ec71eaf442d4fd08b87566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca145c9c1ae7a243e04cf0a778f4584c4bd94670856caf81a8cbaa1b12b1b19d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5137ef34624dc1d60aab6785255f463573817185a5f8c7ddbd522759bf482d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f317b491cfea5a75a3b80ae807030bd39d9de290137567ff124f67f6d685abe4"
    sha256 cellar: :any,                 arm64_linux:   "7aad58121084d70034101aebbb4dc4ea48849d9bb00dc8cfead4f09ae6c15066"
    sha256 cellar: :any,                 x86_64_linux:  "be84342d0c97860051537d8c5e2557e16ffbc8d26cbf5419f8b6bab9532b6e64"
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
