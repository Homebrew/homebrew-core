class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.6.1/libmypaint-1.6.1.tar.xz"
  sha256 "741754f293f6b7668f941506da07cd7725629a793108bb31633fb6c3eae5315f"

  bottle do
    cellar :any
    sha256 "b39e05530f8c774ad55ec574650702881b7801f777da1c63c92eb4034077a891" => :catalina
    sha256 "5bdcfd41c521dd6ad4efd15f529ac978947b08d853bb86aa2991c974388954ea" => :mojave
    sha256 "f9181b00a474d3cf3a31d882075530f43450993c384064d5aadc3f59c2278fcb" => :high_sierra
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
