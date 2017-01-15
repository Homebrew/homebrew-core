class Libming < Formula
  desc "C library for generating Macromedia Flash files"
  homepage "http://www.libming.org"
  url "https://github.com/libming/libming/archive/ming-0_4_7.tar.gz"
  sha256 "118aa1338dd74b34dd2cd22bce286ca0571e8b9aa433999646d1c0157ea9a7dc"

  bottle do
    cellar :any
    rebuild 2
    sha256 "39edc699c3ae41daae0872c8edbf6b5364a428b9579d5ed4d2d66787347de33e" => :sierra
    sha256 "aeead83fb25e5e53f185a5bf3995503b01045abc1f6593246a1622839be7e86c" => :el_capitan
    sha256 "18eeaa97826666b7a0e056f5a954f14b849da4d5e061454cbeeea8405ac71a58" => :yosemite
    sha256 "de61c35147f75601b49728366cf0baa958429c50e2a26f1f1bb7eaf1d697259e" => :mavericks
    sha256 "fe516b67284f8de7a34ed1ac3dc68ee46d0bdb3593db16ba5f62b9e228336144" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "libpng"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-perl",
                          "--enable-python"
    system "make", "DEBUG=", "install"
  end

  test do
    (testpath/"test.c").write <<-'EOS'.undent
      #include <ming.h>
      int main() {
        Ming_setScale(40.0);
        printf("scale %f\n", Ming_getScale());
        return Ming_init() != 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lming", "-I#{include}"
    assert_match "scale 40.0", shell_output("./test")
  end
end
