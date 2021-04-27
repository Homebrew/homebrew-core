class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-4.0.0/apache-arrow-4.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-4.0.0/apache-arrow-4.0.0.tar.gz"
  sha256 "4a31d0bf702e953bdbcda67af10762a33308281bd247fcbd152ee177419649ae"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ba8da1e8724d7ea1c0928b4ce0243c86321b0abfe83e24260eb5f4a5e1a23964"
    sha256 cellar: :any, big_sur:       "83d1cd2b7e609b2511190646ab24b91e791656515273588172ce240a1354608e"
    sha256 cellar: :any, catalina:      "7f9bcc0ec7352d6d509232e4e8c84b7165366177ac855bc639247f67153bf2ce"
    sha256 cellar: :any, mojave:        "409b2858623ac0a4bf06803c26113df6135991bf060a016b3f58dfe1badfa0e3"
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
