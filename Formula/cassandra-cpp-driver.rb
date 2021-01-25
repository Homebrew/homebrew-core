class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.15.3.tar.gz"
  sha256 "eccb53c5151621c3b647fc83781a542cfb93e76687b4178ebce418fc4c817293"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git"

  bottle do
    cellar :any
    sha256 "b5abf1a67997fd3f02c070416e258916e9caa3106034bd19c65289ac61ea8e7c" => :big_sur
    sha256 "c0eb554b6a640eed85988e787af1cfc8320b2b4920f2e88921dcf3ae67661ce1" => :catalina
    sha256 "7600578409910afcb3f14146be2eb7f17cc1eb9c862188b10744dd092f6a80b5" => :mojave
    sha256 "0eb84266667f4b10184e85e74784c000853b0ed4307008bdc8ee93237518a47e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    mkdir "build" do
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
