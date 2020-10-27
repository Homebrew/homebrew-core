class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-2.0.0/apache-arrow-2.0.0.tar.gz"
  sha256 "be0342cc847bb340d86aeaef43596a0b6c1dbf1ede9c789a503d939e01c71fbe"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "eb11280934a5993d540769ec49debb1779659b0ca66dd74638db6f910c97d6d2" => :catalina
    sha256 "fde6a7e909ff674db119a7ce39dedbf12f2e7ac1020612a1e7473ab5803c9abf" => :mojave
    sha256 "c59ea0b6202bf885f4c4605fa1b0b5ef6bcf11b92a49236ddaf0ed5a32e7eb83" => :high_sierra
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
