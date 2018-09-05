class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.10.tar.gz"
  sha256 "1d6ab7800a5b43e56fd20607fd2cfda9e550350dc95f5beb6a4ce14f85b41043"

  bottle do
    cellar :any_skip_relocation
    sha256 "3639281cb395e26811025ffdf00cd566eacd79ad757b3673ee6d2774f8f25c2e" => :mojave
    sha256 "1b9d3e525a8823275e39404117fcd0f28fe2279db0856811d84e3ea49ed08a55" => :high_sierra
    sha256 "8cac78b70d001bdda26c268c42022482af48ba6ffae0231a1f404827336b208a" => :sierra
    sha256 "73730cde2726e217793b2724e2e15ec1b0e21d10eccd769706010a56c379a6d3" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-llz",
                   "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
