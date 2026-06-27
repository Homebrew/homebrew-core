class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.4.tar.xz"
  sha256 "e73a89d68c70f8748aefb6b0f5cfdfec3ff173cf4449837fd6cb17d1e9fcf486"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "87af8837aee8cd1adae1b5661596b5196af8eb3c08c523fc96b9f8b9c0d409db"
    sha256 arm64_sequoia: "a6f4e7e2ed7e8f0de24b5cbc4661b21772c7de37123fe654ba6f3cab9c02bc6a"
    sha256 arm64_sonoma:  "6f1d110f3c3104f99969b8cf31e76b2bc4bff90747d60a2dbc12cdd6dc2331f6"
    sha256 sonoma:        "e54eaf43813a225a89b194f0ca98f799c59a3771a01b3a2b3c9d87a670f5cf05"
    sha256 arm64_linux:   "26c7136c48c5a811762ada7f530bc16c73b0b51b8c41473588215d8e63cec930"
    sha256 x86_64_linux:  "0e948a339951ffe3843a4449ee80abaec0e17ddd2ea5c9378ec1aa0a8660bcf1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %w[
      -Dgtk_doc=false
      -Dtests=false
      -Dinstall_tests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gspell/gspell.h>

      int main(int argc, char *argv[]) {
        const GList *list = gspell_language_get_available();
        return 0;
      }
    C

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(/^icu4c@\d+$/) }
    ENV.prepend_path "PKG_CONFIG_PATH", icu4c.opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs gspell-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
    system "./test"
  end
end
