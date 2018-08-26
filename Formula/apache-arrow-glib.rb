class ApacheArrowGlib < Formula
  desc "GObject Introspection files of Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.10.0/apache-arrow-0.10.0.tar.gz"
  sha256 "943207a2fcc7ba8de0e50bdb6c6ea4e9ed7f7e7bf55f6b426d7f867f559e842d"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "48589b2b5bcd5f93f51b766ce87543f1c62db04258607ab3f24c8ba2df6c7ea1" => :mojave
    sha256 "f1333c883d0f576ff7c817399bd78b945450ef2100427bc862b63cdc51413a8c" => :high_sierra
    sha256 "76066c57519cf7e5ad5a1cb6d7dfd5b08fa8c792f512297ac9563773ba7d18cb" => :sierra
    sha256 "14bc9da622db582d5525d7268fb0769a7eccee19bc747cf2901cd166da1b1bea" => :el_capitan
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
