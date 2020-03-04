class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.5.1/libmypaint-1.5.1.tar.xz"
  sha256 "aef8150a0c84ce2ff6fb24de8d5ffc564845d006f8bad7ed84ee32ed1dd90c2b"

  bottle do
    cellar :any
    sha256 "30e7a9a3ee0a5211cb37e3c59492ee6979e65c3d302d1b2248cf559bc338f125" => :catalina
    sha256 "2008250ff04ff41ec3e7abdc89b283448a699c72c9fb7cfd5562aee94842583a" => :mojave
    sha256 "4d1266b23b828f915323e2e3511aba7c21f6148822020aed000d2f30c8ee7fb6" => :high_sierra
    sha256 "74c7e8fce4bc805d22b952077cf184de788965f0109faf540ce1e909187884e2" => :sierra
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
