class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://live.gnome.org/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.2/json-glib-1.2.6.tar.xz"
  sha256 "958fa59909ef28399c811aff29a5340b330b20660ca3586b4c5aa3a53997776c"

  bottle do
    sha256 "79ffee01030f4a156deb991168ef9df5bf3d331e6d0ddd316fa70c064263a40f" => :sierra
    sha256 "db4ecd54c8dc1b4404ace187f513a157abd4d30fa94fc9f1c55b88389dfcdd8d" => :el_capitan
    sha256 "def4958a5143292442506abe8263a45bbfdb99ad9a732d5e9f9eecc4de0139f5" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/json-glib-1.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -ljson-glib-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
