class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.15.2.tar.gz"
  sha256 "d69a51f2a40da6c450acd95102c2c4693baeae8327cd60aaf4548b23696508ca"
  head "https://github.com/datastax/cpp-driver.git"

  bottle do
    cellar :any
    sha256 "25abbbd19f8ff6ab026f3ccccd466da53e1daeeb52550c85211e833547e4c4aa" => :catalina
    sha256 "49b53bff19ed2897ab07d47bb9db03697a659b55e007c0db0b8d2f0ef70dcb78" => :mojave
    sha256 "0b5b67f7208a2491fa77f5393d993f36e76b23af72d848806b364a2e707c0091" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

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
