class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://download.gnome.org/sources/gxml/0.14/gxml-0.14.1.tar.xz"
  sha256 "9ed5277dd6d9f8aae4f185fe2f0151f146ab18871a48f378e59387383e0e0797"

  bottle do
    sha256 "cdbd97020891f93bf0a7b21d1b904ac601046a59b80869c7add37e629a671798" => :sierra
    sha256 "84ebd4e28631dd103839bbe34d18d601b2f70f3ac731cf95e946dabd4b1230e9" => :el_capitan
    sha256 "883c9f6bdc530b517f4bd8309c2d22513c94c26bab11a69147a2a845f592f17b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "vala" => :build
  depends_on "libxml2"
  depends_on "glib"
  depends_on "libgee"
  depends_on "gobject-introspection"

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
    (testpath/"test.c").write <<-EOS.undent
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
      -I#{include}/gxml-0.14
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
      -lgxml-0.14
      -lintl
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
