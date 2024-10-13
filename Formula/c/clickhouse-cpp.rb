class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "8942fc702eca1f656e59c680c7e464205bffea038b62c1a0ad1f794ee01e7266"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3cda0223506dcc56518dbd70b371ef6757853d01e67ca55c68d2551e9a32b7f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb116ae767d8a4c24d40b04e8839ac3829fe8ec91e35b95e6fc57240ed7ee460"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd89dba1b35ec393371df54f97b29e8634f1269a9882bcde8d4cc69e723e4de3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b02be3ff3f7ce09709380bace6cf7a0d2df5d01e701e1b251479092c99cf82"
    sha256 cellar: :any_skip_relocation, sonoma:         "09ce8d0fb952b3bda5572045ad18c6ed25020cbce2e083a2b60b2f98e73a064c"
    sha256 cellar: :any_skip_relocation, ventura:        "e9b636ce43a3b54279a63e4d1c791fa557ca353d420a96ff016cd1acd24279aa"
    sha256 cellar: :any_skip_relocation, monterey:       "dbcf8a1e4018cf0af46745531ac710a174105e89e661eaff6d18ce77ba6c1e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90fc7c7a8549c0bd752ee992ea04c1cd44d75721a95bd488cb4bf644a55dca28"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "lz4"
  depends_on "openssl@3"

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    # We use the vendored version (1.0.2) of `cityhash` because newer versions
    # break hash compatibility. See:
    #   https://github.com/ClickHouse/clickhouse-cpp/pull/301#issuecomment-1520592157
    args = %W[
      -DWITH_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_SYSTEM_ABSEIL=ON
      -DWITH_SYSTEM_CITYHASH=OFF
      -DWITH_SYSTEM_LZ4=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install vendored `cityhash`.
    (libexec/"lib").install "build/contrib/cityhash/cityhash/libcityhash.a"
  end

  test do
    (testpath/"main.cpp").write <<~EOS
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
    EOS

    args = %W[
      -std=c++17
      -I#{include}
      -L#{lib}
      -lclickhouse-cpp-lib
      -L#{libexec}/lib
      -lcityhash
      -L#{Formula["openssl@3"].opt_lib}
      -lcrypto -lssl
      -L#{Formula["lz4"].opt_lib}
      -llz4
    ]
    system ENV.cxx, "main.cpp", *args, "-o", "test-client"
    assert_match "Exception: fail to connect: ", shell_output("./test-client", 1)
  end
end
