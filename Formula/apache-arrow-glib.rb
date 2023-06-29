class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-12.0.1/apache-arrow-12.0.1.tar.gz"
  sha256 "3481c411393aa15c75e88d93cf8315faf7f43e180fe0790128d3840d417de858"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a6adf9bcdacacc197e0a7f133b9d60bd9f7dfee6e01ee922340109cd23e04480"
    sha256 cellar: :any, arm64_monterey: "6bd32f1271fe76064db9d7aa2ea17490232d32f6cac10154485293fa54086107"
    sha256 cellar: :any, arm64_big_sur:  "3692e580cc146b6234e03fc2b458441c9f352652b9c6a740d8d19edda867ad00"
    sha256 cellar: :any, ventura:        "1ef649611b358abb8b13420614077482f4c96229285fd0a32cb40578a92a0aba"
    sha256 cellar: :any, monterey:       "095a82a7c0aaf064beec224455a22b7534685d6b3f433266fa72889e7a007bbc"
    sha256 cellar: :any, big_sur:        "f540a87468492fb34873e5707710a89d81ea7cf588350ca22e8fb18cabfbc8fc"
    sha256               x86_64_linux:   "7a5217162da3d065ca4089a16f18804eff00ba52f381130607b704bdd931f097"
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
