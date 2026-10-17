class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.5.tar.xz"
  sha256 "788783b56fc3d03283b3aa29302d0b958aeca88835e10b1ec61f19e0efc7e8a4"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256               arm64_golden_gate: "c8a3319bbf2bce3f9c0f4c0a2a911a956774e272fca80436c271943171fa77e9"
    sha256               arm64_tahoe:       "d1d3de757b5073ad648fa1caea8176c23f170f63cc61b4eba1687df695b9c6eb"
    sha256               arm64_sequoia:     "c6036e4f8920b32e95c8b543e9e9c4d856cb53788646a43ad2727e4661953dc5"
    sha256 cellar: :any, arm64_linux:       "f4899d992bdc1eb53eaac7b51fd4ff903b1d82449d34d5c6d631f7e0516de771"
    sha256 cellar: :any, x86_64_linux:      "5c99330509611d825f2e1e6c3a2c7b92dde1711668aa11ad3427d2b02b57522d"
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
  depends_on "icu4c@79"
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
