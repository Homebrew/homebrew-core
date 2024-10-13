class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-1.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-1.2.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.2.tar.gz"
  sha256 "fd6d5662fa706487c48349a758b57bc149ce94ec6c30624ec9fdc473ceabbc8e"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5b70acd6aa97435ecb2abbfdc04f4e31fa3861a37ae7590b0da64704c5c311b5"
    sha256 cellar: :any,                 arm64_sonoma:   "4a1c0f956e528e0fe9a5040da6a2002e221024835916fdc198b5d734e3c2638d"
    sha256 cellar: :any,                 arm64_ventura:  "317dccbd509f4703664238e8d61b1f15c83d298b6d1945578eac33c1e18eab25"
    sha256 cellar: :any,                 arm64_monterey: "4f2cc0abb15a3e11a9b5fe64f874f2b3aff4e763133ba499d91bc65e8745cb21"
    sha256 cellar: :any,                 sonoma:         "e9a705a5442b3ee55f054a695bfbca741ff8a7f31d856ef08a72ad498bd42d60"
    sha256 cellar: :any,                 ventura:        "66091a34396e4e17fc78f31410bf5878091ee6887cec79995f3598093ee481ea"
    sha256 cellar: :any,                 monterey:       "7c53563d2a893c2b204cd667904d7b5ff650a8d153808135f3d6a38cae2b234d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416da7b6b8d158de4adccc0479df3b8cc6a532f39f71df928dd979b01812da21"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if !OS.mac? || MacOS.version < :sonoma
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
