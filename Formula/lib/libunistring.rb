class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftpmirror.gnu.org/gnu/libunistring/libunistring-1.4.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libunistring/libunistring-1.4.1.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.4.1.tar.gz"
  sha256 "12542ad7619470efd95a623174dcd4b364f2483caf708c6bee837cb53a54cb9d"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9abc2b3782640cabca4ee0e0e2072478f4eab5c3c74bfdb8a9fbf2eff80c4b1"
    sha256 cellar: :any,                 arm64_sequoia: "dbc874f78025281d97cf683531c635a6a4195b928f1af4288bda71e6dba723cd"
    sha256 cellar: :any,                 arm64_sonoma:  "7b03a079d5408f0d111accb2331f8f881fbb9e395ee05a583ca436c218ff44e1"
    sha256 cellar: :any,                 sonoma:        "4e3960f18ae73ba2bdb6b046431c9fac5936138cb68f454752b8e7de0aea54f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79d9d9e62971a416bff77be8f9b50251514941a859f4a92c469e7996ffe715c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f870ec882a5579d1d26fe194454b7c32559268cc0854758b85690385ce844d32"
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
