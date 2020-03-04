class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.5.1/libmypaint-1.5.1.tar.xz"
  sha256 "aef8150a0c84ce2ff6fb24de8d5ffc564845d006f8bad7ed84ee32ed1dd90c2b"

  bottle do
    cellar :any
    sha256 "6fd3f26062bfc994f3d1e1542b4b7aa366b3f9fbad003c3feb03563906b3a5a4" => :catalina
    sha256 "3789bdf45148ec909acbdcf8eb0a36d3b6139ecdddd956311cd9bb8824172092" => :mojave
    sha256 "fdbe9d46b48f23ac9a096f161d6319d461a618d7eba6620d9746005f1b165611" => :high_sierra
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
