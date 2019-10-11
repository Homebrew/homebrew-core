class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/5.6.1.tar.gz"
  sha256 "deff863023950b1d1de7e47e44fc31c8ba39cfc06334737261965f697b2ad312"
  revision 1

  bottle do
    cellar :any
    sha256 "6ff16ffeba1e2f9f4dfa957c0d0e9162752c6207b7c9c0056aa2e8a01e0c2f83" => :catalina
    sha256 "3bf2cb84c29f3adc952220837cfb160b65ab3950c90abec406bc2534c346a7a2" => :mojave
    sha256 "50821931ec368541e13b4dd04da11f17f4a77b2feebdbf6f424f3d518fbacad7" => :high_sierra
    sha256 "331ea1c86eb7873af94626b4d90f6b3aa4ca9ad1627b066643be19c46981a4c8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-x11",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make"
    cd "tests" do
      system "make", "testbits"
      system "./testbits"
    end
    system "make", "install"
  end

  test do
    # Since no headers are installed, we just test that we can link with
    # libgdiplus
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
