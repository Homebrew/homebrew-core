class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftpmirror.gnu.org/gnu/libunistring/libunistring-1.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libunistring/libunistring-1.4.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.4.tar.gz"
  sha256 "f7e39ddeca18858ecdd02c60d1d5374fcdcbbcdb6b68a391f8497cb1cb2cf3f7"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "786069d2b7c7d1e0facd9f91b3dac9cc43542fa0c0bd803ba403afbf960ecfa9"
    sha256 cellar: :any,                 arm64_sequoia: "b171ead2e22c6dade5cdfe57523dbc9c75f7203051674f558e59ee942727052e"
    sha256 cellar: :any,                 arm64_sonoma:  "46f7419a625bceba16fde2c4e8647191e68952c3f56647c08af7263e638a205b"
    sha256 cellar: :any,                 sonoma:        "4ce329b0ae9efb007adac2e147ae85eb9a80b586bc03c1dbd845fbb1ddbbd712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e206ac8762414c62e2885267759cc1357c440b4025e5179e4973d04185a838b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0d176a4f4f76bde5a7af9aeba760891538ce002ca7bc96a445bfa20cef36251"
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
