class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "f694395ab49e7c2380297710761a40718278cefd86f4f692d3f8ce4293e1335f"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6e3824acd6cbc7fb6eb0fca264341b71ce231bb8bcf9c49a8d2068233963616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2fe3c51ac226cc47312483cf41ae089775ba3352d0c9165d4d2fc31f737992"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b493b2c517dbcf968bc3573dfdf9c0dd45573095272fc3a53922aca7ce51af"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e34322b12d40a1c6a31a8a17448aed7c6ded46057340afe14bf3fe0be89acdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b147b1c1087b24fb84ca2dc42691de39e60f24e12f774af1c1c701073646c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f392feecc378fec9d916616f84fc2ba97d96fb6910098cf5ceeb4b22e026bd"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"

  def install
    # We use the vendored version (1.0.2) of `cityhash` because newer versions
    # break hash compatibility. See:
    #   https://github.com/ClickHouse/clickhouse-cpp/pull/301#issuecomment-1520592157
    rm_r(Dir["contrib/*"] - ["contrib/cityhash"])
    args = %W[
      -DWITH_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
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
      -L#{Formula["openssl@3"].opt_lib} -lcrypto -lssl
      -L#{Formula["lz4"].opt_lib} -llz4
      -L#{Formula["zstd"].opt_lib} -lzstd
    ]
    args += %W[-L#{libexec}/lib -lcityhash] if OS.mac?
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end
