class Libming < Formula
  desc "C library for generating Macromedia Flash files"
  homepage "http://www.libming.org"
  url "https://github.com/libming/libming/archive/ming-0_4_7.tar.gz"
  sha256 "118aa1338dd74b34dd2cd22bce286ca0571e8b9aa433999646d1c0157ea9a7dc"
  revision 1

  bottle do
    cellar :any
    sha256 "40d795df57d1e133795eec2398be3009c12f4fde529da0ce58ae7890c15fe93d" => :sierra
    sha256 "d94345b9515ac352ab1da123536f28d431c99d70cfde7e31110a6b18186d7a8d" => :el_capitan
    sha256 "2fc3c18b64fe9cacdc0c5098d9d9a1b8b672aedd660208949e227b98241cac08" => :yosemite
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
