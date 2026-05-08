class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "51b9592f4b348d7aa0e5b598ed75c781ee9e3dd6f671e6d198dda3a6c5a7b222"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "818ece612ed4a302ee0dcd877173b627dc625c177303fc07fec95aaf6d1e81ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c16a93d6b8d4ad58f6ef7a1f515096f33a44b6f9b6773a9419de72d89eaa1ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8002b62519b3da6207aa49190637f283a483a064304455066e7992920c71307"
    sha256 cellar: :any_skip_relocation, sonoma:        "73d35fdb7f7ccf11c694391a9c67c02504a5491d47556584bb97199994a090f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca0d5daf8d385e5be6cafafaf4d7d64a6ab4c12c47e4ed6825a0e5bb1fb53f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae484d44f11192568191882fca27e0a80d56aac59109aa2c4ab1ad2601514ab0"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "zstd"

  def install
    # We use the vendored version (1.0.2) of `cityhash` because newer versions
    # break hash compatibility. See:
    #   https://github.com/ClickHouse/clickhouse-cpp/pull/301#issuecomment-1520592157
    rm_r(Dir["contrib/*"] - ["contrib/cityhash"])
    args = %W[
      -DWITH_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@4"].opt_prefix}
      -DWITH_SYSTEM_ABSEIL=ON
      -DWITH_SYSTEM_CITYHASH=OFF
      -DWITH_SYSTEM_LZ4=O
      -DWITH_SYSTEM_ZSTD=ON
    ]
    # Upstream only allows building static libs on macOS
    # See: https://github.com/ClickHouse/clickhouse-cpp/pull/219#issuecomment-1362928064
    args << "-DBUILD_SHARED_LIBS=ON" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install vendored `cityhash`.
    (libexec/"lib").install "build/contrib/cityhash/cityhash/libcityhash.a" if OS.mac?
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
      -L#{Formula["openssl@4"].opt_lib} -lcrypto -lssl
      -L#{Formula["lz4"].opt_lib} -llz4
      -L#{Formula["zstd"].opt_lib} -lzstd
    ]
    args += %W[-L#{libexec}/lib -lcityhash] if OS.mac?
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end
