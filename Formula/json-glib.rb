class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.6/json-glib-1.6.2.tar.xz"
  sha256 "a33d66c6d038bda46b910c6c6d59c4e15db014e363dc997a0414c2e07d134f24"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "f84ff6cd5b2e0295f55fec084791de5d78cc8eceab6af8c2bbccff7534aa370a"
    sha256 big_sur:       "1f91e53ac2d8364a97b28a02cbf01d95458679548d09d5ed2b7e64b0bc6daabe"
    sha256 catalina:      "53f88d2001e5050f25d1faa331112eb7ec706ce8fb67fa737fa0213b34980975"
    sha256 mojave:        "47e4851f7cb0b4b54f2fc789bff2d38bf143f4c0d29e785797344ecdf87a8ef6"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=enabled", ".."
      system "ninja"
      system "ninja", "install"
    end
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
      -ljson-glib-1.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
