class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-1.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-1.0.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.0.tar.gz"
  sha256 "3c0184c0e492d7c208ce31d25dd1d2c58f0c3ed6cbbe032c5b248cddad318544"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "25cdc9367877f369283d003e0d092c7fb8fef6f0b973a9571e1d2a8d097920f2"
    sha256 cellar: :any,                 arm64_monterey: "b8b2f6fe30eefd002bf0dbb5fc0e5c6dc0d5f9b9219f4d6fcddc48e3bc229b23"
    sha256 cellar: :any,                 arm64_big_sur:  "df13d54b58c8c86c0e609f7343677175eae0a58ba0cceabbceb08023d23021c3"
    sha256 cellar: :any,                 ventura:        "09262440edd6c32576dae1d6aad94900ce6559df0ef3cff3de232d75b2ddbdcf"
    sha256 cellar: :any,                 monterey:       "18a1691229db1dbc9c716236df52f447aa9949121c36ae65b4d6fdf284d260c6"
    sha256 cellar: :any,                 big_sur:        "50c3003f7db296810b0fbebdb86d94edd88f56195c48327f615d6ef52608628e"
    sha256 cellar: :any,                 catalina:       "3b5bb302d087ae03b3a87b0d722a3db1a66dc83ff45f77e624a62590c3d0c95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d76e62d1bafe89c7535ca21aad48fe99370b5353d0c4efeafe564db367401d"
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
