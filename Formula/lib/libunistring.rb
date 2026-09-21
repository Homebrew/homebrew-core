class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftpmirror.gnu.org/libunistring/libunistring-1.4.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libunistring/libunistring-1.4.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.4.2.tar.gz"
  sha256 "e82664b170064e62331962126b259d452d53b227bb4a93ab20040d846fec01d8"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "57307eb89a02e09aa4de70e09391994dfc9520d9f101ec7e64f9af21dcea2420"
    sha256 cellar: :any, arm64_tahoe:       "14a72bd0aa3f1b2b3a7360be24380171d140b2fc5abbde0144807d3847b6728c"
    sha256 cellar: :any, arm64_sequoia:     "513bf2378982459bf3daf286cec9d50d3f491686f8caa8749604de3be4e6db77"
    sha256 cellar: :any, arm64_linux:       "27ac70a1873a544d1602e2c23a60feab68707d8a5403fb686567ce94ef08e2cd"
    sha256 cellar: :any, x86_64_linux:      "a1153bcda606e120f9bf8e7e274d102e9f87a517c88fc8324c488ffdf1cfce71"
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
