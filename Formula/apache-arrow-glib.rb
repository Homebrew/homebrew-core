class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.15.0/apache-arrow-0.15.0.tar.gz"
  sha256 "d1072d8c4bf9166949f4b722a89350a88b7c8912f51642a5d52283448acdfd58"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "0a1a6599e93388aa7567661e5af0cd361d5b26b2e28385dc13f89e50fbc0167a" => :catalina
    sha256 "06a11044cd8957f2f7614732755e4d600ded92dec7efe8ed2307f2b276db5a19" => :mojave
    sha256 "c89167305832f45e22ecdac81f042adec69122487f16f93b5ff510c0418ea6f6" => :high_sierra
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
