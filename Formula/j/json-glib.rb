class JsonGlib < Formula
  desc "Library for JSON, based on GLib"
  homepage "https://wiki.gnome.org/Projects/JsonGlib"
  url "https://download.gnome.org/sources/json-glib/1.10/json-glib-1.10.6.tar.xz"
  sha256 "77f4bcbf9339528f166b8073458693f0a20b77b7059dbc2db61746a1928b0293"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "3d00d4a1266924534b5adcc93273d5e8ce51a6342aa2f9c956a3860bc9ee218c"
    sha256 arm64_sonoma:  "c6b20089f3b7f27bd3f8d8a7bbc4c1b5e73ac3677c3cb78db538e70a329627b5"
    sha256 arm64_ventura: "589f8ee092ec28365af94a19290a8c81e6801ffab80ba903df2eeff613a1ae4f"
    sha256 sonoma:        "5946d972c9810bd218ca76da8209e2f54f99db9c34614e93ab0c387b368393a2"
    sha256 ventura:       "121e1fcafb0fb6c77e9bbc8dec4e1b19a22325e20b9780a07edf149ee0038851"
    sha256 arm64_linux:   "b9434fd258c9196dc5a2108c2d0de4a46f520496048182f4a1757384b6b094c8"
    sha256 x86_64_linux:  "76ef98939b04b41babd95e8b680b43266986d73dbc783bd5e79d8dadc296df4c"
  end

  depends_on "docutils" => :build # for rst2man
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

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
    (testpath/"test.c").write <<~C
      #include <json-glib/json-glib.h>

      int main(int argc, char *argv[]) {
        JsonParser *parser = json_parser_new();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs json-glib-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
