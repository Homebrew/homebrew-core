class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.6.1.tar.gz"
  sha256 "4b60fd25bbb04dbc82ea09cd9e1df4f975f68e1b2e4293078ae14e01218a22bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "be5da6be7ba9b82a4ababc2200099084367c35c53f4636245b79cbd1f8d9253d"
    sha256 cellar: :any,                 arm64_monterey: "89a3b2b6421ac6af1652eb01aa6c9d6e0ee0cc171fb19f8d7f65933d1e38eac7"
    sha256 cellar: :any,                 arm64_big_sur:  "c4fee4b22461d6ec27e29c4a396a590d9b8ac02d2aac1000ed964c2a33898b37"
    sha256 cellar: :any,                 ventura:        "d2f97aa422ac2d7dfa9ba2c5a3677b9bc4c5dd495ae756afd19a93b296229133"
    sha256 cellar: :any,                 monterey:       "3aad61de788fc4219c444f7f3adfa33c8c7ab5680dc2e2f8fdfb744fe9625a9d"
    sha256 cellar: :any,                 big_sur:        "baacfbe43787c4cff1ea3dd2efbc1be2c94d36155742017b0cd3df0ef3b9f1e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d069e1ff2518b96e9f3ea7249fd0fa484055569cad1e3070acab4466658a653"
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
