class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.11.tar.gz"
  sha256 "6c5c5f8759d1ab7c4c3c53788ea2d9daad04aeddcf338226893f8ff134914d36"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d43e434cb121e5fd9c1be9adfc0ff6c8afa8f51c786a5b855117eb6f3e9e2dd" => :catalina
    sha256 "3c28dea3721b03227d660c7c453673d3cb40f00f41e2e4ba3f163a7171926da0" => :mojave
    sha256 "a49b8dfcf257d31c46841a733f1925020dd49493554d049a479467e602e3e796" => :high_sierra
    sha256 "3c6df94a873fc2268478e10c23d1aa631c6b29e1afff38de63e2839ad0f1968c" => :sierra
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
