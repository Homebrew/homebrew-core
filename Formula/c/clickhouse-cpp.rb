class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "8942fc702eca1f656e59c680c7e464205bffea038b62c1a0ad1f794ee01e7266"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0654e0226efe59eb3660e155e851b6aa8cb522e5457a60d44008838f936114e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99586f86f929be3f524a69be3e1ad4fd4bec9f25fcb3f55d3f7401753cd068d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10b3d4147d44d1850c64c5593e57113b6ee0f646217bf73098ac0c63a254378b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc32dffac451b190139c200241b37b0b6d7e0835efdbb74156552451b8b57377"
    sha256 cellar: :any_skip_relocation, sonoma:        "4809344e248635dfc707f436f5e3b55cf4ea0e9bc792347687d8e65f1c492a52"
    sha256 cellar: :any_skip_relocation, ventura:       "0af47d43ff24d655e84ed146acbc08ddc3fbe58e4ad428aa77ebe4d955ed5a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd7ba2866a45d7db1dd11dd76a254d9decb177d0463b96aef556902e5c9620f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "632c681d02c3b5261da20562567ec7e0bfcce88e6abde92d13b24fad35662498"
  end

  head do
    url "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"
    depends_on "zstd"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "lz4"
  depends_on "openssl@3"

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
      -DWITH_SYSTEM_LZ4=ON
    ]
    # Upstream only allows building static libs on macOS
    # See: https://github.com/ClickHouse/clickhouse-cpp/pull/219#issuecomment-1362928064
    args << "-DBUILD_SHARED_LIBS=ON" unless OS.mac?

    if build.stable?
      # Workaround for CMake 4 until next release with:
      # https://github.com/ClickHouse/clickhouse-cpp/commit/56155829273bf428aebd9c501c2ff898058fafea
      odie "Remove CMake 4 workaround!" if version > "2.5.1"
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5.2"
    else
      args << "-DWITH_SYSTEM_ZSTD=ON"
    end

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
      -std=c++17
      -I#{include}
      -L#{lib}
      -lclickhouse-cpp-lib
      -L#{Formula["openssl@3"].opt_lib}
      -lcrypto -lssl
      -L#{Formula["lz4"].opt_lib}
      -llz4
    ]
    args += %W[-L#{libexec}/lib -lcityhash] if OS.mac?
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end
