class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-1.0.0/apache-arrow-1.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-1.0.0/apache-arrow-1.0.0.tar.gz"
  sha256 "86ddb9feb48203a5aaf9cc4f2827525e20a2ca4d7239e492af17e74532ccf243"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "91b2ef2ce4bd4eea4e424fb5f0762ecac997d5152a9b1c9ae5ab76b0e743d152" => :catalina
    sha256 "9f2299d887246872c3bee18ceccfd623f575a569975d0cd30f527964641f4a53" => :mojave
    sha256 "40ff7f66e31c0f34c24cf05664d2f85888c66006e5cc03fd1bc239a437ca68fe" => :high_sierra
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
