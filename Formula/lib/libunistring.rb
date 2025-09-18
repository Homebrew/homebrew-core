class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftpmirror.gnu.org/gnu/libunistring/libunistring-1.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libunistring/libunistring-1.3.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.3.tar.gz"
  sha256 "8ea8ccf86c09dd801c8cac19878e804e54f707cf69884371130d20bde68386b7"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "640e9f79172d25b6b74cdc9084d9bc5fdee2afd6e6412b732852d14807ceb645"
    sha256 cellar: :any,                 arm64_sequoia: "0cc291557b61cc7d02936f50d8ee84eb109b5ee4ebc5070175b6eb78d2210d9f"
    sha256 cellar: :any,                 arm64_sonoma:  "97bdae1108cd8f835cbebd34e29aad5079582c12b670aa55ca4513a68857aae7"
    sha256 cellar: :any,                 arm64_ventura: "af27e48e970fd7f05e3aafe1f0aca3ae6ffce74cb193e8d85b0fec26c2860292"
    sha256 cellar: :any,                 sonoma:        "464e4554828d664abca64dc50d62f99d100d72d54907c6bb8829ec4029e63656"
    sha256 cellar: :any,                 ventura:       "25be9fa66a76ecbafe9812b4e30a45d0455a8031386fe1373416a97b90c7e75b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "199d018f82fa63ad011465e9bcbbfd66cf737b764fd66a3ca9002e9f7db1de84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "411b23b4ca5b77f9e57d22aed7dd9dc9b465d9581c0d5db452f157b1333abdf9"
  end

  def install
    # macOS iconv implementation is slightly broken since Sonoma.
    # This is also why we skip `make check`.
    # https://github.com/coreutils/gnulib/commit/bab130878fe57086921fa7024d328341758ed453
    # https://savannah.gnu.org/bugs/?65686
    use_iconv_workaround = OS.mac? && MacOS.version >= :sonoma
    ENV["am_cv_func_iconv_works"] = "yes" if use_iconv_workaround
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check" unless use_iconv_workaround
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lunistring",
                   "-o", "test"
    assert_equal "🍺", shell_output("./test").chomp
  end
end
