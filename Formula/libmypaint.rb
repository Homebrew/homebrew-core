class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz"
  sha256 "6a07d9d57fea60f68d218a953ce91b168975a003db24de6ac01ad69dcc94a671"
  revision 1

  bottle do
    cellar :any
    sha256 "68b0c292a4746962bd04ba9505e62b78d5041e98ecfced4487feeeb21463c771" => :mojave
    sha256 "6122c05f8e69340980719443229bcc7b0afee9a47ec036a9c788957f52ca39d3" => :high_sierra
    sha256 "eab6dea7366aac3115ef655ac1dc77a1b07c63c775924b27e87f0c7e93200d2d" => :sierra
    sha256 "d7402148eaf2c7d18fa7c2fdefe62ca27cd181146dabea1ab8eae15e03b53ce6" => :el_capitan
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
