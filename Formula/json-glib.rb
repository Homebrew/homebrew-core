class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.6/json-glib-1.6.6.tar.xz"
  sha256 "96ec98be7a91f6dde33636720e3da2ff6ecbb90e76ccaa49497f31a6855a490e"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "753f1b417f67019352dd2241a506056d3a61d517143983963bbf100d0bf39305"
    sha256 arm64_monterey: "2905d1e62cc0d99fd5bb240b0899401d2dc667f317d07d19378a0cccea01bf48"
    sha256 arm64_big_sur:  "e74f3f36f6388489d5940ee05c290ad6f7164d65a141d31384ba4c7454bc9064"
    sha256 ventura:        "bc74ee2868329c5484a5d98ce1e612f9f135f209a62e3f5ed7b80b2f446899d5"
    sha256 monterey:       "c9e3f1128cf4ac8db8ca28ca88ab72a3fb6c50a3ce0c9df5fc394ed5c95b38b3"
    sha256 big_sur:        "223b8bc85f42b9a68bbca1ccfce4e6daff89c0e51275ec26cb9a0a012b7bceeb"
    sha256 x86_64_linux:   "3fae78dea79874ebb00176ac6e7d1af0972d47da744ad30b4d189d765098653f"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "libxslt" => :build # for xsltproc

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Dintrospection=enabled", "-Dman=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
