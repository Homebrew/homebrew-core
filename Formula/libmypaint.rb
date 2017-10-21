class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz"
  sha256 "6a07d9d57fea60f68d218a953ce91b168975a003db24de6ac01ad69dcc94a671"

  bottle do
    cellar :any
    sha256 "1397d27d48875ec00d4c926bc72569abe68aaeaa2080fa84ec70ded1339ece4f" => :high_sierra
    sha256 "713c83d8bffaf3aefbfe692bee7e568427eee277b2168de172761633643f1df9" => :sierra
    sha256 "7511afd642619eccd9a0fdb2ff25ff2ff0e451ed6cb2e544ed8cdefaacb2a11a" => :el_capitan
    sha256 "4587871608abf371b5f691d33a5f2fb081d38b5de3794a67729ac9f09f7cc880" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
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
