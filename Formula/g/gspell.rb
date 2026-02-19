class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.2.tar.xz"
  sha256 "4ec7e5accc9013281bacd6bbc00006be733818b81ba3fe332c1e876c7e1e1477"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "910030c441215ec024db92eac8652575af98e253e94aecda784087b7aa0584a8"
    sha256 arm64_sequoia: "1a0d15b6f0b4bfea5f8f95c2d0dd3d59ebb2460dfe281c9c414a1d7d5fbd0df7"
    sha256 arm64_sonoma:  "170bafd3850a59ca95dd8ed8dff9bc3b5c9f06c8dff01f312c0a2d0e0490c153"
    sha256 sonoma:        "a62c410a3c93e63d9d4bd0f953bb654f50b18ece134eabe490d6a9c7e5dac73b"
    sha256 arm64_linux:   "8b1eae35e33876edd53df086cd3d73edec9792b96b8c3e8ee43f635a073a6f83"
    sha256 x86_64_linux:  "4136e6107b59ab142d2fe841bc07a158c6616b5ad7586e0b63110523938d60fb"
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
