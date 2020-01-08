class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-0.9.10.tar.xz"
  sha256 "eb8fb2c3e4b6e2d336608377050892b54c3c983b646c561836550863003c05d7"

  bottle do
    cellar :any
    sha256 "ce746662b98d93511b86920011b5cafcd2eecbce4c9c40d8c52a143cdf708456" => :catalina
    sha256 "1d0c8e266acddcebeef3d9f6162d6f7fa0b193f5f71837174fb2ef0b39d324f3" => :mojave
    sha256 "5eeec8fdede3d6ae2c1082179879a41d3b600a36e7d83acc5ea0587ad85d5a9d" => :high_sierra
    sha256 "3a7a0e8737c19995bc8a263724a90a26b418b177deee90b4e6746c353b348e12" => :sierra
    sha256 "df01e794e8d11926ea023798f9f95d516a6c28009cbdfd29ea1d1a9107812d66" => :el_capitan
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
