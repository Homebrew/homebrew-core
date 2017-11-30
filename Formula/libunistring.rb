class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-0.9.8.tar.xz"
  sha256 "7b9338cf52706facb2e18587dceda2fbc4a2a3519efa1e15a3f2a68193942f80"

  bottle do
    cellar :any
    sha256 "ab87b179bc5ac0d54cbf003d62fdae4e0924e7cf5e1dba67af70fdd65668f5cd" => :high_sierra
    sha256 "d82c6b7c72707aa04eb00bd3e6a4a995ef830b41b02271111ee6006585eaca80" => :sierra
    sha256 "c80c64fdd7d05bf0e387b3286238e1740e7989098ba6bde403151a1c14d57812" => :el_capitan
    sha256 "e2143b25bf7bdc85ddb00b065cf1f72c665d77a6737563cd81a88420bc72e51f" => :yosemite
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
