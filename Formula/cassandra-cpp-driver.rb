class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.15.0.tar.gz"
  sha256 "8cccffc7f3b7a8edc51c5c4344fd6a60d5a7beec27a1a3fd52742003a2675cb9"
  head "https://github.com/datastax/cpp-driver.git"

  bottle do
    cellar :any
    sha256 "87a85e45ad3f626199da825b1479f1924627560f40cd9d19a79e72f2f2d27035" => :catalina
    sha256 "1b557a5511b6b6cfe63e014c926f410a93c19ab40495f9cfa3cd8d2386b90168" => :mojave
    sha256 "c68d0fefa318bd3409d065bee3ad7b6bb75d86a2f4239e4cebef0f402e8b88e8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
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
