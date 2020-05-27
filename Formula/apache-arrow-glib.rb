class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-0.17.1/apache-arrow-0.17.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.17.1/apache-arrow-0.17.1.tar.gz"
  sha256 "cbc51c343bca08b10f7f1b2ef15cb15057c30e5e9017cfcee18337b7e2da9ea2"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "e21d3b56afd84a1987c187911ef181bc55a40553ef431c249903641e921ce686" => :catalina
    sha256 "6947d273ccb270e39f191da00cb267248b667392f64a14eea7c3f7fb79218a29" => :mojave
    sha256 "75cf8ec68ad7b86de7333cd2355cdbf0ace4610a8cdaff2f1309d79851b62dc2" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  def install
    cd "c_glib" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
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
