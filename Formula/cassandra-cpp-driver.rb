class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.15.1.tar.gz"
  sha256 "b3095e154f10d7a740dfa3155f66be50880b0110a06dd02dd097f1121a72d88d"
  head "https://github.com/datastax/cpp-driver.git"

  bottle do
    cellar :any
    sha256 "8f627dfc937ea72d165ab5ee6fbe64a34678a38cd1554d08748d1a5ee25adefb" => :catalina
    sha256 "ed9625ca853c0efb87431debb42c359ad9ba11ed707c1cbb6063de563243457c" => :mojave
    sha256 "d69c44c6d8a15dffadf3ec853544812c513a14060909e34db252e4b63895768f" => :high_sierra
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
