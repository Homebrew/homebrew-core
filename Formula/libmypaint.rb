class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.6.1/libmypaint-1.6.1.tar.xz"
  sha256 "741754f293f6b7668f941506da07cd7725629a793108bb31633fb6c3eae5315f"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "b481fb4e3ed5cb542d1ef073a5852a0a65361f0825051302ccdd6bc224901d90"
    sha256 cellar: :any, arm64_big_sur:  "4f5f706833fb183d4ad43a0b065b2b767a7787e7963eabced95016bd04ffdd12"
    sha256 cellar: :any, monterey:       "30623690f18dafe72d96daad871d4f7018ab3e89970ebdeda2fbf2d56c781c68"
    sha256 cellar: :any, big_sur:        "65d3c8c494c5e3a454526e4254c4f4c1a1883ca1e99c2dcb09c2abdff141d72a"
    sha256 cellar: :any, catalina:       "699014970a67055822e7ee2abc92c4ea2b45e51bcd58cfa01cb24c2ed08f6a2b"
    sha256 cellar: :any, mojave:         "97ca6e5c0ae27513cc3af20c1256548d6a21e0a38bfdcea5a79f7fe1c0a6886d"
    sha256 cellar: :any, high_sierra:    "4260697ececf5344aa3eacd16afdd5f4eff556cee6312e49a8e5544edb71aca1"
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
