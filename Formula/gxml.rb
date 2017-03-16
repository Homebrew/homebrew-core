class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://download.gnome.org/sources/gxml/0.14/gxml-0.14.0.tar.xz"
  sha256 "3e1f28ba6fc06b5c96a57c1f099ad3bc21683c54bb3b5e5bc4d7ceaff7c74066"

  bottle do
    sha256 "c278bf77ee2598784234af1831fbcec240884f8752f063b13be414e6771ea9e2" => :sierra
    sha256 "d469006c231e641e60fad6af24830e7ca1228359c884e844461c90ea672596f5" => :el_capitan
    sha256 "863382cf1bb3bac00b2443bf6d17701db99fc3c22be9ffd440c5043868b15936" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "vala" => :build
  # remove next three lines when next release is out
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libxml2"
  depends_on "glib"
  depends_on "libgee"
  depends_on "gobject-introspection"

  # see https://bugzilla.gnome.org/show_bug.cgi?id=779836
  # should be fixed in next version
  patch do
    url "https://git.gnome.org/browse/gxml/patch/?id=0829fd0b83941efe85ec45e6c4900d76ca0c5b29"
    sha256 "984b9a3e5a7cfa125b3b0b5e479d1f185005c1c90612f809e320a4d0617bb8a9"
  end

  def install
    # remove when next release is out
    system "autoreconf", "-i"

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
