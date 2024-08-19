class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.8/json-glib-1.8.0.tar.xz"
  sha256 "97ef5eb92ca811039ad50a65f06633f1aae64792789307be7170795d8b319454"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "fbe3c0724f164ccdee84f32d1b69c77d1a107e44a3da3a61143ac7c22f2fc1dd"
    sha256 arm64_ventura:  "b593108eeb37d792eb9ef773159457d25516dabd2be4cea505154838c8878035"
    sha256 arm64_monterey: "8996945cc14f5da7a9d99e9ef9d2ca8d72eeee82366a115376d8ec3e7fc84c87"
    sha256 arm64_big_sur:  "51081c6d5e7536d4318e6e3242187b2e1ed6bbe8406c327c3d04718d468f4abc"
    sha256 sonoma:         "2d5b69e36b373c3290404997fce2861ff93051d090893387d63ae46684327c19"
    sha256 ventura:        "7029704cd9940fac2877a284b3af4b3cf357449e1655c732dd83a50ee1b7bb4e"
    sha256 monterey:       "0613f8b663813f0437152fc6eda96d7b5b494a5b0e4fdc8812aa23a1c8823a58"
    sha256 big_sur:        "c41242bb352c932355cee7f76f218765009635e8ccde86875b5ac8ca2ba5099a"
    sha256 x86_64_linux:   "4cc13206b988e32ae264a4cc41e97fe7e0fa7d123f4903109e50583634d2140b"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"

  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

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
