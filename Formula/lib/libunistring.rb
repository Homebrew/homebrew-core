class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftpmirror.gnu.org/gnu/libunistring/libunistring-1.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libunistring/libunistring-1.4.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.4.2.tar.gz"
  sha256 "e82664b170064e62331962126b259d452d53b227bb4a93ab20040d846fec01d8"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bae6d6d8dffc573c039a850a96e36f1b7fd846abd9ccada8260b7e888b5a3646"
    sha256 cellar: :any,                 arm64_sequoia: "463b68c92d30d845df10b1b137aa8e41a744f1ce2d2cab024dd26c766335b797"
    sha256 cellar: :any,                 arm64_sonoma:  "dc4d4b4406a2c7032dd838ae362ecaeba114d8ac9d9daaa18f760d1d71ba3577"
    sha256 cellar: :any,                 sonoma:        "fbb3a7908a19f306823dbd51b417705c73f710a9a1fb1e34ba7aa67a3c966094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "362f8bd62dc8a3db8ca85938b2bfc7ebd09bd3d4f676ae1491183239d576b7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2491acf49407cf75d5f95a6296f2a1c0294646834022fdcad7e22471c0c9a6d4"
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
