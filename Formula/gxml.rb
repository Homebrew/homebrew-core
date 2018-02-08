class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://download.gnome.org/sources/gxml/0.16/gxml-0.16.2.tar.xz"
  sha256 "e2c68c2a59c351066469cbf93ccae51c796f49e0d48639aed72af39c544dcef3"

  bottle do
    sha256 "5b4890263a3636be938bc956d9478ee3807155372bb2741af3005f09d580c7ed" => :high_sierra
    sha256 "2ff16e5287f53a41945a694caf71687cde140489b0ee9b3263c850ebe970a635" => :sierra
    sha256 "8d1c7be3713f7cdaaa7d75b189eac0d9b18e4fa8fad0dfc5b96cb3414ba675a0" => :el_capitan
  end

  depends_on "gtk-doc" => :build
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
