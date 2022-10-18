class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.16.2.tar.gz"
  sha256 "de60751bd575b5364c2c5a17a24a40f3058264ea2ee6fef19de126ae550febc9"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "64ed2de59c0135b2a2854c3797ba35301c8e195261c8d3fa22be15e7e0f6213a"
    sha256 cellar: :any,                 arm64_big_sur:  "7b0a531d7126d0156ddb87365462739b3f1fedc09a8dc16d3962d60405e6dc27"
    sha256 cellar: :any,                 monterey:       "c43517117152e217a879d11c94793c4b3dfe89d88c3482775342a331ac2400a0"
    sha256 cellar: :any,                 big_sur:        "40e7b2c90c71303e92a7a42f0722a6802c4b420084b2e6fbef91b6d8a9135f8b"
    sha256 cellar: :any,                 catalina:       "5789724888e6c63971817c676a6fb4508993ec220b5b837fbda1bfccb9ac09bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f81a2d5931a0d5132d72509b07970a1c110bb7e80910acfcbd345caa65e48dac"
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DLIBUV_ROOT_DIR=#{Formula["libuv"].opt_prefix}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcassandra", "-o", "test"
    assert_equal "connection failed", shell_output("./test")
  end
end
