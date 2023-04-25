class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "336a1d0b4c4d6bd67bd272afab3bdac51695f8b0e93dd6c85d4d774d6c7df8ad"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbef733518c0db6ed44b0cef6404e18931718cede114322f8286b3805f66eaac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "832ab5b4293a1e679362b0372a7c2c1592ae0696a68e1a11c4bd830f02d4bce6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b351441e8bc0618c90e285dd3d037f62846053cd9d64e7b1ce091e849a64bfc"
    sha256 cellar: :any_skip_relocation, ventura:        "1b0b4016fbcdd6ca38d3daf8342c9ee0625909c2d8967778ddd5726e6bdfb492"
    sha256 cellar: :any_skip_relocation, monterey:       "d94e36b761d07d1ca7fe412aca4eca341ecb7f0a07c9097630b8b188b543239c"
    sha256 cellar: :any_skip_relocation, big_sur:        "23c2a0dc054127550d5ab81af90c86e14cb96a9b4574285659cc68b5d1ee20a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be6a37caf5dc7c724af5b25efa434571eedc716e265513d6463ff3f1a5be3320"
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
