class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.16.2.tar.gz"
  sha256 "de60751bd575b5364c2c5a17a24a40f3058264ea2ee6fef19de126ae550febc9"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1f94b7c0d0411f6c14267d82f7161a885fb740854ad919e738e3de2fe79f6837"
    sha256 cellar: :any,                 arm64_monterey: "9bc308348bd4255276447d174fc29a2c542213bf169408363896dfc49956ca35"
    sha256 cellar: :any,                 arm64_big_sur:  "cac923a6c616a2e1bc661803649147b908087590f92a1481715c41b03bd326c0"
    sha256 cellar: :any,                 ventura:        "a9a4ab72c7ced27cf60d95b402659425e946dad16bd3eaa35f66ac8b1eedf929"
    sha256 cellar: :any,                 monterey:       "d2b5345fb271d6828ee7dd30066e9052130ccce62290d08e679e2d0d461ee778"
    sha256 cellar: :any,                 big_sur:        "55ff95e3125b9b9fb85e77b3a41f11b76f3717cc9d8ed444e86d12bd50c52e6c"
    sha256 cellar: :any,                 catalina:       "388592bafbc1a2d775cea095a5fc7bbb81996542eac910ae00621af12803ed9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e70a2b4e18cf01957a124f1f5143102d03a8a20d9ad650f48a5241278aa14d"
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
