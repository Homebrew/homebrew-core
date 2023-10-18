class CassandraCppDriver < Formula
  desc "DataStax C/C++ Driver for Apache Cassandra"
  homepage "https://docs.datastax.com/en/developer/cpp-driver/latest"
  url "https://github.com/datastax/cpp-driver/archive/2.17.0.tar.gz"
  sha256 "075af6a6920b0a8b12e37b8e5aa335b0c7919334aa1b451642668e6e37c5372f"
  license "Apache-2.0"
  head "https://github.com/datastax/cpp-driver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b60f48fe3cb1655bda7864a812512b0f869dfdc02ec1c26cbcd6c9e22199c98"
    sha256 cellar: :any,                 arm64_ventura:  "f2c0f84c604ce004d37cd749bb37340f647fd5abc51d0acbeef3e1bb29b44cba"
    sha256 cellar: :any,                 arm64_monterey: "b171190fe175ef14558beb72ec499301c3dc6351fea12aab1659b42ce7f027b0"
    sha256 cellar: :any,                 arm64_big_sur:  "db0e37ce8d95554dfe8812adcd74d6df1745deb9aed5a2afc829942447939609"
    sha256 cellar: :any,                 sonoma:         "07a243027b0a2a87fe7fdc111e53d07d3e1f3192b6c5d4a384d82023719b5a42"
    sha256 cellar: :any,                 ventura:        "cf5ffec87eec474e78e9144d912d1251082bffae3bafa34980d6b86ddb9e1100"
    sha256 cellar: :any,                 monterey:       "922860104f8a70e3678b183dcf72846569978467c716785f6e5fc2cb92e8c2c5"
    sha256 cellar: :any,                 big_sur:        "e7625ecdf2d1638dcb076dc8b3860a0919af3b86b4fc3791b7cad3b00f8d7bfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f8f67baa1eb5712c113cdcb4802ee3f4f857e1055f7981d1970c2c47622afad"
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
