class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-1.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-1.1.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.1.tar.gz"
  sha256 "a2252beeec830ac444b9f68d6b38ad883db19919db35b52222cf827c385bdb6a"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c78e7b0af88bef155ad7f12d63ad60f0c87e5a8cccb8f40ec5d9304f8fdfaee7"
    sha256 cellar: :any,                 arm64_monterey: "4224b6d2525c68567fba97103f44fe6f95e62990bddab83e4849d048f3799cda"
    sha256 cellar: :any,                 arm64_big_sur:  "91c48a9bed24806ed74c964ac39010de737a83ca8a4f2b29e07180902112985e"
    sha256 cellar: :any,                 ventura:        "10dbdabb2d2fd8465ee4b89196dda6fc80e80fbb61425d42f0bf1e3ee3476145"
    sha256 cellar: :any,                 monterey:       "73ef01fda8958a495f4d7031cb8d270432d4ae2f11760190676762b95ac7c0f4"
    sha256 cellar: :any,                 big_sur:        "55a30f8d2ad0058a9869751ccb9b7e949469cf20f29810e70ff2b7eff63a6762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "252f3716191a8c08f8d10e2c20b84cf9645e2c264f409f58d3255d9a4edce77f"
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
      #include <unistr.h>
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
