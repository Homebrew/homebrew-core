class ApacheArrowGlib < Formula
  desc "GObject Introspection files of Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.11.1/apache-arrow-0.11.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.11.1/apache-arrow-0.11.1.tar.gz"
  sha256 "c524f3d47f0cdb7445c0326b20e79f60485e12daeb2adc8ad6a845ad6c19c1ac"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "e191d5cc56f40a85d9b7e7a258972381fbad66fbbb7fd894c7d9aff51aacfc55" => :mojave
    sha256 "844ab89fcc76e32ad16fc9f012fcfa37138d4f035c991d0482bf357470dfff85" => :high_sierra
    sha256 "2521430e830e0f7a7d6c7f09dbff30511443da4bbad3386c657935370cd46686" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "gettext"
  depends_on "glib"

  def install
    cd "c_glib" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <arrow-glib/arrow-glib.h>
      int main(void){
        GArrowNullArray *array = garrow_null_array_new(10);
        return 0;
      }
    EOS
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
