class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.0.tar.xz"
  sha256 "64ea1d8e9edc1c25b45a920e80daf67559d1866ffcd7f8432fecfea6d0fe8897"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 arm64_sequoia: "03106944ffad6a23ddd95ca647a7808698374337309aba617c63d11eb4a47130"
    sha256 arm64_sonoma:  "3c67a5a4434cc8faa2b0abe80843891a565dd81afdca0e4aff24b71ae2896f6f"
    sha256 arm64_ventura: "9a1ea15e3f7b7b0c7213d63f565cad2e312fae9a6f5c1ef4b76c632d3f43b831"
    sha256 sonoma:        "055cb331155fc7a4627c5e27f09491285922fe28967fb2e3af7296711ce961e0"
    sha256 ventura:       "5713495649b5b21951f2e39574b9335333298276f9c96dfe5ffb3cf03f5e96e8"
    sha256 x86_64_linux:  "b6fa120befbae62fff98ae659831ef563b621fe32e8b1c137b79cb401360feed"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
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
    flags = shell_output("pkg-config --cflags --libs gspell-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
    system "./test"
  end
end
