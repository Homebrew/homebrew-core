class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.10/json-glib-1.10.0.tar.xz"
  sha256 "1bca8d66d96106ecc147df3133b95a5bb784f1fa6f15d06dd7c1a8fb4a10af7b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia:  "cd747264afa25b324bfdb8db502067ec3db1e4bf3f08aba588f85f6d0fd686e5"
    sha256 arm64_sonoma:   "a5774cddeca544bfdfed17aa3d1c83dd8bcfa92404cd667388909ab8de5bb529"
    sha256 arm64_ventura:  "980cdf31daf005701ca36e96802fea798fd75b47ba418c6d6fbef292e29899e4"
    sha256 arm64_monterey: "c801e7e3532f910456f49da96b4069e383f6cab8b2b2a7396a277c7dc68e0407"
    sha256 sonoma:         "8a5afc698f6d5c910a553d400b86452d11b78a16e1ca41b4b3644ca9795e5ced"
    sha256 ventura:        "b626deb80ae8b8746bf73ef3ff8e0784c9c8b11081e0d2017b86e59515679f3a"
    sha256 monterey:       "36d442758daaa2de90249d6902a0795f9c33270c0e2f0caf4ec232437b04372f"
    sha256 x86_64_linux:   "5c542473aaf27baee38f1a953c4796ed5b564055b8aa58c395d9a3689145dda8"
  end

  depends_on "docutils" => :build # for rst2man
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"

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
