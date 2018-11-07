class ApacheArrowGlib < Formula
  desc "GObject Introspection files of Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.11.0/apache-arrow-0.11.0.tar.gz"
  sha256 "1838faa3775e082062ad832942ebc03aaf95386c0284288346ddae0632be855d"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "9d58dfee64715bec7d6ea0a4e317e4928677e8520490ef43e1e7d99cda32151e" => :mojave
    sha256 "6934d5beb0ac0676f791dfdde2ad29bd8a68e55a1d38f736a91f6c0f4fa76ea0" => :high_sierra
    sha256 "e5f0675b346a403710a168bba522a1d5652652e9fffadeefb3e09c7f7ab44787" => :sierra
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
