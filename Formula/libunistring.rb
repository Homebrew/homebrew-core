class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-0.9.9.tar.xz"
  sha256 "a4d993ecfce16cf503ff7579f5da64619cee66226fb3b998dafb706190d9a833"

  bottle do
    cellar :any
    sha256 "6c072527173fa59aa703e5d4ccd4fe7b350de7e0f6091423f7a3973e0bfbc201" => :high_sierra
    sha256 "57ddedc5c2277d3cc8ac3f7ec223363ed5ebec048b1b66fd9f29ceaa6ddfa0c8" => :sierra
    sha256 "93138d92e44116c1acd8ad64edcb30e8407a2e1723c4cb6061426fdbf5beafff" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uniname.h>
      #include <unistdio.h>
      #include <stdio.h>
      #include <stdlib.h>
      int main (void) {
        uint32_t s[2] = {};
        uint8_t buff[12] = {};
        if (u32_uctomb (s, unicode_name_character ("BEER MUG"), sizeof s) != 1) abort();
        if (u8_sprintf (buff, "%llU", s) != 4) abort();
        printf ("%s\\n", buff);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lunistring",
                   "-o", "test"
    assert_equal "🍺", shell_output("./test").chomp
  end
end
