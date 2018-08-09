class ApacheArrowGlib < Formula
  desc "GObject Introspection files of Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.10.0/apache-arrow-0.10.0.tar.gz"
  sha256 "943207a2fcc7ba8de0e50bdb6c6ea4e9ed7f7e7bf55f6b426d7f867f559e842d"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "0b8cb603832498d39701d8f1ff1bf7f7dbb51814fcae6ae79df12920bcc804b8" => :high_sierra
    sha256 "824eb129eddd32f0fdef0105340947ff32865e1cb4857de0723ee63ced886ee1" => :sierra
    sha256 "54acc8b9d157b6f2762876bc5e126a45a1f51d8361f29b500bda72c984627ac2" => :el_capitan
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
