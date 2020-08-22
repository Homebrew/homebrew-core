class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-1.0.1/apache-arrow-1.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-1.0.1/apache-arrow-1.0.1.tar.gz"
  sha256 "149ca6aa969ac5742f3b30d1f69a6931a533fd1db8b96712e60bf386a26dc75c"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "9b665624077b7eab70266b768c2e1a16039e85580d994045a6a87b5582fa126f" => :catalina
    sha256 "a2701485e70e016fd2560d8736cf3724ffc367c4345832e1fbd61103afdaf001" => :mojave
    sha256 "139ec7427d44de82a538125f9d686f689f2d01a4b5afeecb785e80888c678141" => :high_sierra
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
