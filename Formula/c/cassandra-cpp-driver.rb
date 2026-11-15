class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  license "Apache-2.0"
  head "https://github.com/apache/cassandra-cpp-driver.git", branch: "trunk"

  stable do
    url "https://github.com/apache/cassandra-cpp-driver/archive/refs/tags/2.17.1.tar.gz"
    sha256 "e6ab5f5c60a916dd6c0dd9a19a883a4a1ab3d6b4e95cab925a186fecff08344e"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/apache/cassandra-cpp-driver/commit/b01f0dcfbec419ffeaee31f9a61f4bc86f790dec.patch?full_index=1"
      sha256 "b7d1aa90d4ad45cdfa119cfdc944ed1d7a0f743404dd242fed323be49a02417c"
      type :backport
      resolves "https://github.com/apache/cassandra-cpp-driver/pull/590"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "ee344876ddd0520a78ef1ed0a19df5985dc55f05e241d0c46ad5a11f023c558b"
    sha256 cellar: :any, arm64_tahoe:       "aed7c57c257aefb388dec385c067714c9a7a25ba6b3a447ba302bf9897e8e88d"
    sha256 cellar: :any, arm64_sequoia:     "71cca948b550d6adf308cc90e7e47b0c204d5d3b1b582a030f367a10bf249835"
    sha256 cellar: :any, arm64_linux:       "9dfef249c57a2e01bd1d646ffad6efad3bf8e0f15fee463eaf8d7e494fb4340d"
    sha256 cellar: :any, x86_64_linux:      "9a50199d1ddbf8d60fe7ea0140267d1f20df7b118a2af326453ecea2f4a62e97"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@4"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Fix to error: Unsupported compiler: AppleClang
    inreplace "CMakeLists.txt", 'STREQUAL "Clang"', 'STREQUAL "AppleClang"' if OS.mac?

    # Workaround for CMake 4 compatibility
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DLIBUV_ROOT_DIR=#{formula_opt_prefix("libuv")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cassandra.h>

      int main(int argc, char* argv[]) {
        CassCluster* cluster = cass_cluster_new();
        CassSession* session = cass_session_new();

        CassFuture* future = cass_session_connect(session, cluster);

        // Because we haven't set any contact points, this connection
        // should fail even if a server is running locally
        CassError error = cass_future_error_code(future);
        if (error != CASS_OK) {
          printf("connection failed");
        }

        cass_future_free(future);

        cass_session_free(session);
        cass_cluster_free(cluster);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcassandra", "-o", "test"
    assert_equal "connection failed", shell_output("./test")
  end
end
