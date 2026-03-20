class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/apache/cassandra-cpp-driver/archive/refs/tags/2.17.1.tar.gz"
  sha256 "e6ab5f5c60a916dd6c0dd9a19a883a4a1ab3d6b4e95cab925a186fecff08344e"
  license "Apache-2.0"
  head "https://github.com/apache/cassandra-cpp-driver.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2eac7917c3f056f8a39dbb3d1aa116dfdc801a0d77f707cf2bab60fc1f8ed683"
    sha256 cellar: :any,                 arm64_sequoia: "256afb7d9c6714eec5a02780209860cc95ece3f567894869e32db6d6d2b8b263"
    sha256 cellar: :any,                 arm64_sonoma:  "3122c1edeab450972cc0d8def34f9ade786ddc243c45f1e935789c45f010cf43"
    sha256 cellar: :any,                 sonoma:        "7c8786ed29acf59ef1b011d03f81baf332ce48e5f2e62e4e1a07fe69695b1a9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa58ca621b780e38766318102c90118144b2e79f2f93caeabb051bf8f96ceff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8425e4bf6558162f770e4c9b4c61f153b1d52a79a1e6f8d77d4f5d145399b9b"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@3"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    # Fix to error: Unsupported compiler: AppleClang
    inreplace "CMakeLists.txt", 'STREQUAL "Clang"', 'STREQUAL "AppleClang"' if OS.mac?

    # Workaround for CMake 4 compatibility
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DLIBUV_ROOT_DIR=#{Formula["libuv"].opt_prefix}
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
