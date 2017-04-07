class Libming < Formula
  desc "C library for generating Macromedia Flash files"
  homepage "http://www.libming.org"
  url "https://github.com/libming/libming/archive/ming-0_4_7.tar.gz"
  sha256 "118aa1338dd74b34dd2cd22bce286ca0571e8b9aa433999646d1c0157ea9a7dc"
  revision 1

  bottle do
    cellar :any
    sha256 "f2daccad7d66a0bf6ccf2ce0cee83ef9f773477286038ceb4469e847b636051c" => :sierra
    sha256 "49f6955f38c979b30b505ad35a7acac3aab6810af6782d38810c8ac6683ab4b9" => :el_capitan
    sha256 "9defad751430a07e4c6fe3b25eba08fc690425a0502b5bbac904efe6d9a85d73" => :yosemite
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
