class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://live.gnome.org/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.2/json-glib-1.2.2.tar.xz"
  sha256 "ea128ab52a824fcd06e5448fbb2bd8d9a13740d51c66d445828edba71321a621"

  bottle do
    sha256 "be50545abc36b43fe093e29eda2692246111d8c37a3d154537724485e12a86a4" => :sierra
    sha256 "7ae820550037c8df9fb51976bcdd72079a94ebcac9e1afdf1c84a5d819ff1f08" => :el_capitan
    sha256 "5ff0ceedf7b85ad8ac06a3bbb9eac249c0ae73da2723c25b321ce6174824d564" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
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
