class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.16.0.tar.gz"
  sha256 "35b0f4bac3d17fef47e28611dbeb51e07639395e957f23f4a3cc60770db1ab9c"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "dffbd12b312992799953020da8bca5dc5c94f2ad5ed43e2c4e25272ef8fdf960"
    sha256 cellar: :any, big_sur:       "e9fc8a0a6d868e206b46897bc8d832ac4b061e59de28a4c7187dc41e8700886d"
    sha256 cellar: :any, catalina:      "c7f2bc1a273c6501ab8ee167824187f806cb78d82be37db0396d78d10d57675b"
    sha256 cellar: :any, mojave:        "2c0c5813a8ca8e2e8b900b494479c90f27bd71f2124ee9dd55ffb95aa517cbf5"
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
      system "cmake", "..", *std_cmake_args, "-DLIBUV_ROOT_DIR=#{Formula["libuv"].opt_prefix}"
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
