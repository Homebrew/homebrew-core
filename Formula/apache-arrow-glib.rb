class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-4.0.1/apache-arrow-4.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-4.0.1/apache-arrow-4.0.1.tar.gz"
  sha256 "75ccbfa276b925c6b1c978a920ff2f30c4b0d3fdf8b51777915b6f69a211896e"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "600724d980ea538d2a018fd29bbab7a8c7b81d54fb406f600e76152e513c16a8"
    sha256 cellar: :any, big_sur:       "545368f552ce0ed5efcce4e055e47d32a76adf28394e897996e9140e9b179c82"
    sha256 cellar: :any, catalina:      "18b37c1d11b457939f96c19d13c51d978195735d2d2cedc7ab70134742a86fd4"
    sha256 cellar: :any, mojave:        "b31ff5ffe9898c5c306b76b956075e882f0f098bf6d2c091bde912a2c6b70cae"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "../c_glib"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
