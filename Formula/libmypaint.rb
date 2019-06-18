class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz"
  sha256 "6a07d9d57fea60f68d218a953ce91b168975a003db24de6ac01ad69dcc94a671"
  revision 2

  bottle do
    cellar :any
    sha256 "dfe7c264c268506950dfcb40bdc27bb034efc546c0ff4301b50eec73885fe371" => :mojave
    sha256 "69bbf6753092623b42ecc493e0ed466b891434d6781fa525169f4726d22765dc" => :high_sierra
    sha256 "13615549309382dfb311e6a2d5898e2d89edd6134e9a87a244242c87932f1c67" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"

  def install
    system "./configure", "--disable-introspection",
                          "--without-glib",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mypaint-brush.h>
      int main() {
        MyPaintBrush *brush = mypaint_brush_new();
        mypaint_brush_unref(brush);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libmypaint", "-L#{lib}", "-lmypaint", "-o", "test"
    system "./test"
  end
end
