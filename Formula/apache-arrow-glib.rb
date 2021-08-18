class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-5.0.0/apache-arrow-5.0.0.tar.gz"
  sha256 "c3b4313eca594c20f761a836719721aaf0760001af896baec3ab64420ff9910a"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "master"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "37c2b194b6c0648b40a2627dabdf9073ef280bcb85c3633a1b528636b00ef9e7"
    sha256 cellar: :any, big_sur:       "feb4e5e5d8257e0ab042fe905f999ff425cf219641d64bb98e5b6f4226104436"
    sha256 cellar: :any, catalina:      "5017136d50cb3b2159370f6c2f2d2824607504e6e7f317b5a7c55a7f02437884"
    sha256 cellar: :any, mojave:        "40980b2ef3e926109475f08522df24aa409f7d40252738ee7f5d2fd32a8b0bd9"
    sha256               x86_64_linux:  "00de00e057ffeafdc424efb6fb102fd233e349e589d1954fd347ae7e0f05157d"
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
