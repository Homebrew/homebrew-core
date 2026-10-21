class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftpmirror.gnu.org/libunistring/libunistring-1.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libunistring/libunistring-1.5.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.5.tar.gz"
  sha256 "5b0ecd46cbf225375f20ab4056197e66a7ac590e2684c069af407ae3383c9d81"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fec6be46cabaefd1dc5d5ecd029c50aeaef6c93d9c7de4425968047811575e81"
    sha256 cellar: :any, arm64_tahoe:       "b803434415743b204ffc6bc5415ebfceeaf3dbcb86c0c4ea8a6fc63d2a04f441"
    sha256 cellar: :any, arm64_sequoia:     "5001abe192babcfaf0f97ad322e2e59958d0d991de3da9f2e941b24924b8a2b8"
    sha256 cellar: :any, arm64_linux:       "142d02125d023a6908f2f407ab5b89f5fd5a9382d363d5f0b627b81d5a19f8f5"
    sha256 cellar: :any, x86_64_linux:      "8064362db7a4b0a036feb1e0eb4513b1604da1b14fde4b7f3866d067d24808ca"
  end

  deny_network_access!

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
