class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.3.tar.xz"
  sha256 "e8b39c67556f75495362952f81ca241b5a3c17c75960b77fc93fa702c612a5a4"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "36da9381aa9011726e9c7c425a3f7723606f9dfea27c821f60b9f7236ab863ee"
    sha256 arm64_sequoia: "a7215bb0f1b92a26f9e24038f1a99b6ede7b504c7c543f4b5fb6a06a0f74bdc3"
    sha256 arm64_sonoma:  "3f7b78a875626ae35214f1143d94f19036eae21336c5a00ee1bb4230714ff56e"
    sha256 sonoma:        "6014def47ac458969afdeb4cf672b0ee50b6c02f52f70f8034ad2f22056686ea"
    sha256 arm64_linux:   "00815cf404aaa7f036ca40686b60961b90f5d9f6bab4465721aa2e71dd4613c3"
    sha256 x86_64_linux:  "c7ffe182b68ab3ff701927cd247b05391e16e0731349abb4a913009ff859ced5"
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
