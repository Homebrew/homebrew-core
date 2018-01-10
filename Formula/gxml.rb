class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://download.gnome.org/sources/gxml/0.16/gxml-0.16.0.tar.xz"
  sha256 "2c08019d5b7aec3efd6a5223517ed8e29840b14aed009cdaf0ef96e4ef6e99af"

  bottle do
    sha256 "52c57777587cd0b7aa9aab0f854ffaa5c1b3a571c205ba849b2bd6e58ebb1c0e" => :high_sierra
    sha256 "0822d594967ff897b5da4f78312bcb4acaa0ffa7e2ac046e4c1e07569d6726f7" => :sierra
    sha256 "ab52ecbdd84a6213ac2d96ed167d4e367b3f980360e1aa5b0cfd3e118717dd38" => :el_capitan
    sha256 "c515994080f2dab325b5777142a785bb6ba8c42a0c0a5bf89f5a6d25e1fd8bd1" => :yosemite
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
