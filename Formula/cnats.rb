class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.0.0.tar.gz"
  sha256 "e10beeb623fc5dadd0673269674331f7b35d19e52ff32d14ceac981b3c701587"
  revision 1

  bottle do
    cellar :any
    sha256 "edd1c5bb6f1f53f55cd6ce37747296e18a4058169a216cbf2cffd38992782142" => :mojave
    sha256 "21e635453416ef371f04e5557c537b23cba302429075e5a6e44f1962e57194ab" => :high_sierra
    sha256 "d49a379b532fc1aaaa42e0b11d8c75e84b0ffa3dfeba4b67fb34474cb43c431c" => :sierra
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
