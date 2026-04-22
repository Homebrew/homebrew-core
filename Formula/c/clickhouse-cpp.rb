class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "51b9592f4b348d7aa0e5b598ed75c781ee9e3dd6f671e6d198dda3a6c5a7b222"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f07f29ec90bdf515cdc5399f615de9ca8e1d74995fa1409002c1ef5bbff99bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34706e41232f75ae5bbbe5bcad025ae6115d7b01b1ca74df8a290c26d9888d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5526e518fa331f167952d51a03b9ab77600651c5859b1d997f3ac82b42ce7c28"
    sha256 cellar: :any_skip_relocation, sonoma:        "8495d22062c587986ddad967e3bb7a2e82ce1a7ed02b9911aa055c1753ea4c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9822d275136deb4aa978f117fe6745cb71593826640832cc379a995a49246a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd67e96e427e490a49e9c0b22f0d0a1d2810f19fd8317e28279bba0b92ef38fe"
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
