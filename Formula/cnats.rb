class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.6.1.tar.gz"
  sha256 "4b60fd25bbb04dbc82ea09cd9e1df4f975f68e1b2e4293078ae14e01218a22bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0206e5e928601734724c60181977137bcc6fa32b661d63f53da3300b5352334c"
    sha256 cellar: :any,                 arm64_monterey: "a1ffcbe87f824bcc71e784a5d7cf862aa5ad86a9b4265ab994ceac5d933df7fe"
    sha256 cellar: :any,                 arm64_big_sur:  "1852d2fe52411a4650cfc693da25674caeb860971d62b6a710702a68f099a5eb"
    sha256 cellar: :any,                 ventura:        "803bfd6031c7ea72bb65a66a7f36f3d0e9f13a7f5b788650543ac60857a366c4"
    sha256 cellar: :any,                 monterey:       "cebc878eb1694191da1b023ce1c8381d335ecc8b2f949a0580c9bf449f48383d"
    sha256 cellar: :any,                 big_sur:        "77d0b288a68a03ab5f7ca1250231ebe5133798dc5f93654feef8c238d1f51f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2340adc3d278aaeb0897d7c5f3b53055cb7305b5e0b5ce2ace93d9b223cc2e04"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
