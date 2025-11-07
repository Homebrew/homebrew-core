class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.0.tar.xz"
  sha256 "64ea1d8e9edc1c25b45a920e80daf67559d1866ffcd7f8432fecfea6d0fe8897"
  license "LGPL-2.1-or-later"
  revision 4

  bottle do
    sha256 arm64_tahoe:   "91a5e1fb5d1aa6c8636a5e5bab3c52c4f62e83638d3864f0a6c8885019efb3c8"
    sha256 arm64_sequoia: "8b1df275aa6cbc4f4c0151604ede17c1c08a1a91ee5bca764aec7bdf805fbb18"
    sha256 arm64_sonoma:  "35e901810b4f741b4c1f9db969ff3a57368ca60c204f706ea1befaafeee60ae9"
    sha256 sonoma:        "b92576cb9b42266307ccb3d69e4de14479c2145fdcb420864d65bbca42b213aa"
    sha256 arm64_linux:   "5a4280fa6e90599f95cefa8b456649a4d59129fd59699234240c2c982b9c6f7a"
    sha256 x86_64_linux:  "d08727eb047fc1c639cd3c3362ccf789d7da29a41f98322084c841ff8e070ae1"
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
