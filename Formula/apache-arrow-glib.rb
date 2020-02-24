class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-0.16.0/apache-arrow-0.16.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.16.0/apache-arrow-0.16.0.tar.gz"
  sha256 "261992de4029a1593195ff4000501503bd403146471b3168bd2cc414ad0fb7f5"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "53ec05d5303a8436826b0e2d5f63c75e02c0d94f4e9603e9320c51215da50592" => :catalina
    sha256 "e39f24b25d36332864fc4af1fbe8c4b043c77a029d5f02927cb30428502bd522" => :mojave
    sha256 "f7232a9864c688cc6147a921f6f000be309009a45921f4461e469ef0f2214873" => :high_sierra
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
