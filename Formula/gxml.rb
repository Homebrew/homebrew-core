class Gxml < Formula
  desc "GObject-based XML DOM API"
  homepage "https://wiki.gnome.org/GXml"
  url "https://download.gnome.org/sources/gxml/0.18/gxml-0.18.1.tar.xz"
  sha256 "bac5bc82c39423c1dbbfd89235f4a9b03b69cfcd3188905359ce81747b6400ed"

  bottle do
    sha256 "4eb68617f73471be697746b879fe118fb3e116a1e911a2f95541982a77cd4714" => :catalina
    sha256 "b9bb621d776f10dc1c3a9bde25964bd26847bf49cdee49ada1c0407f5fb14dbb" => :mojave
    sha256 "4253e9a1bd9ce221e2287e5d53d39342c65fd06aa63028aa56effae2514854b4" => :high_sierra
    sha256 "47042a94c013db905170cc0c373b8f7000d77e9c75d2d17dbacad6cd658e6b56" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgee"
  depends_on "libxml2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
      -I#{include}/gxml-0.18
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
      -lgxml-0.18
      -lintl
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
