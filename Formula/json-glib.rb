class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://live.gnome.org/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.2/json-glib-1.2.8.tar.xz"
  sha256 "fd55a9037d39e7a10f0db64309f5f0265fa32ec962bf85066087b83a2807f40a"
  revision 1

  bottle do
    sha256 "0d3c18248dee24bc64f7f17dff22e6effc72b2e1ca27d813b668468944802c05" => :high_sierra
    sha256 "359c57e2a47a525c066aa39e2ff2a70a076080b2d5f868fc1286bbc5121f82eb" => :sierra
    sha256 "4eeb1cf4803bdb2bd15d7576591de7c6c316a2fa5f9a958591549f4f4ce79697" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
