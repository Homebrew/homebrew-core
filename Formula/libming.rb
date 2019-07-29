class Libming < Formula
  desc "C library for generating Macromedia Flash files"
  homepage "http://www.libming.org"
  url "https://github.com/libming/libming/archive/ming-0_4_8.tar.gz"
  sha256 "2a44cc8b7f6506adaa990027397b6e0f60ba0e3c1fe8c9514be5eb8e22b2375c"

  bottle do
    cellar :any
    sha256 "a752e52ef310c943317df0e8adfbd31fe44724123f4a11e7b7ed7055e15730c8" => :mojave
    sha256 "e8e2645d0bfafa6b62bf209f6259a1a433fb23632fa9b5048cd407d13fa9b2d2" => :high_sierra
    sha256 "38b7d494355b3b2368dffe806814b62accd9bb8a2bcdd2c3d000449a7cb0a316" => :sierra
    sha256 "c9a220b978be081b1f202b5964c2231a38eb8ea415746bb4d9b4f73bd03325ae" => :el_capitan
    sha256 "dcab3bcff475f2b5266dbbd6e86c65223dc20aa2372544b2b55842e401f564bd" => :yosemite
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
    (testpath/"test.c").write <<~'EOS'
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
