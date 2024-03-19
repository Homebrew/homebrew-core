class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-15.0.1/apache-arrow-15.0.1.tar.gz"
  sha256 "55db63ed9fd6917b7abfe5d4186c9f532cbe48aa53f4040d57e7c29ad70bcefa"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "da019c9cab3a75c3a4756ca61063d58e5db87eaf7102c352f9c9e711857a2636"
    sha256 cellar: :any, arm64_ventura:  "216bd3b1235e30ac8bcad5c31265d4dca28a0bd4bbdf8c854a1859b425c89ffb"
    sha256 cellar: :any, arm64_monterey: "7b0c632d8d66156dcae42fd989b14b84e4e407d4aade62bd78e366d609df87b8"
    sha256 cellar: :any, sonoma:         "f9134a2d4dce662361654d7690ae6bc158fa24492b4b3ee830e684dcb7d5c8ae"
    sha256 cellar: :any, ventura:        "f27d91cbd4e87508ebfcf3543de1702e604de44737492677578d97d07ba70d0b"
    sha256 cellar: :any, monterey:       "9eca85882812f642f562823de74ee8536270ffb55b14dda66de97023a98a9dea"
    sha256               x86_64_linux:   "97bbd8d330d7fbb156f99faf4ce73355e92746904b63e807bf993be2c163399b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "c_glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~SOURCE
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    SOURCE
    apache_arrow = Formula["apache-arrow"]
    glib = Formula["glib"]
    flags = %W[
      -I#{include}
      -I#{apache_arrow.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{apache_arrow.opt_lib}
      -L#{glib.opt_lib}
      -DNDEBUG
      -larrow-glib
      -larrow
      -lglib-2.0
      -lgobject-2.0
      -lgio-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
