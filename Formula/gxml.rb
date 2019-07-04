class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://download.gnome.org/sources/gxml/0.18/gxml-0.18.0.tar.xz"
  sha256 "5760933fc4c48d13d54f101271d4872fbf3082ab2ef202b14bbb64202fcf05eb"

  bottle do
    sha256 "6a9de82882c75a57b891a82d5033f7d72ff145b61e30e180ad4339223694b194" => :mojave
    sha256 "2f92dacc64c00a008a9d9a78b9bcc863fc204fce8f83d8a4493a45c61134902a" => :high_sierra
    sha256 "3dc0c7f3322afc0c4a7c5517759e9c2d0241915236b9f8016d134fb94eac6380" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libxml2"

  def install
    # ensures that the gobject-introspection files remain within the keg
    inreplace "gxml/Makefile.in" do |s|
      s.gsub! "@HAVE_INTROSPECTION_TRUE@girdir = $(INTROSPECTION_GIRDIR)",
              "@HAVE_INTROSPECTION_TRUE@girdir = $(datadir)/gir-1.0"
      s.gsub! "@HAVE_INTROSPECTION_TRUE@typelibdir = $(INTROSPECTION_TYPELIBDIR)",
              "@HAVE_INTROSPECTION_TRUE@typelibdir = $(libdir)/girepository-1.0"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gxml/gxml.h>

      int main(int argc, char *argv[]) {
        GType type = gxml_document_get_type();
        return 0;
      }
    EOS
    libxml2 = Formula["libxml2"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libgee = Formula["libgee"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{libxml2.opt_include}/libxml2
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gxml-0.16
      -I#{libgee.opt_include}/gee-0.8
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libxml2.opt_lib}
      -L#{lib}
      -lgee-0.8
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgxml-0.16
      -lintl
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
