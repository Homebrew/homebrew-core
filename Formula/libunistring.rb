class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-0.9.10.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.gz"
  sha256 "a82e5b333339a88ea4608e4635479a1cfb2e01aafb925e1290b65710d43f610b"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_monterey: "dfe303fd657d52e618cd9f355897adce5ea58f05459956546b94e6d24557376d"
    sha256 cellar: :any, arm64_big_sur:  "73cc290ebcefd6354329317266d9e110e3a5967d0a8260d2cf7d4dd3edc9218c"
    sha256 cellar: :any, monterey:       "a7407af4a0cf1b07bebbd1969c635346ef4aa2572a670d0051408de744060f27"
    sha256 cellar: :any, big_sur:        "5d336bd939f678b48dc1ced97ed0def383999638d80caa8cb2da780594556524"
    sha256 cellar: :any, catalina:       "ce746662b98d93511b86920011b5cafcd2eecbce4c9c40d8c52a143cdf708456"
    sha256 cellar: :any, mojave:         "1d0c8e266acddcebeef3d9f6162d6f7fa0b193f5f71837174fb2ef0b39d324f3"
    sha256 cellar: :any, high_sierra:    "5eeec8fdede3d6ae2c1082179879a41d3b600a36e7d83acc5ea0587ad85d5a9d"
    sha256 cellar: :any, sierra:         "3a7a0e8737c19995bc8a263724a90a26b418b177deee90b4e6746c353b348e12"
    sha256 cellar: :any, el_capitan:     "df01e794e8d11926ea023798f9f95d516a6c28009cbdfd29ea1d1a9107812d66"
    sha256               x86_64_linux:   "9559d7f4530f0b0e3c78dfa051368fccbb36acfdc1aa50b4feaa3b43be6aa10c"
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
