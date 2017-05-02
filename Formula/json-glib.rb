class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://live.gnome.org/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.2/json-glib-1.2.8.tar.xz"
  sha256 "fd55a9037d39e7a10f0db64309f5f0265fa32ec962bf85066087b83a2807f40a"

  bottle do
    sha256 "3faa6b4be8e06f768fc550e7373edccd09ec308e00a65fd48a01eb46f0d77bac" => :sierra
    sha256 "d26028a584955b8ebe2002261ccd34cd8ef8b5f287b6da211276fb981bd405dd" => :el_capitan
    sha256 "6bd1f2ed688b6f637a942400d55fc6f4e51db40887421a80b1ffcce185d3e084" => :yosemite
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
