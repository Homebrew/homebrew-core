class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.6.tar.xz"
  sha256 "d02a6f1ff3cf324798f184062a6777302ef4b325deab277d8469d3816c69282d"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    manifest_sha256 "5eab33389450735e34ee6d8f3d4772f26a88da51f9a0ac7e696b78f8da401e25"
    sha256               arm64_golden_gate: "bbdc7a46fb1b3fdf42715145dc13f7aafa0918bba6267f8f350f363e1fa28f68"
    sha256               arm64_tahoe:       "93988cd51a1e82fbe8a5724874ab99e2567eadf24a973e377b87af90cf02de23"
    sha256               arm64_sequoia:     "cdb3e628c5c857836599465b0d02774cbec7cb494847e076d173864c4e3dcf8a"
    sha256 cellar: :any, arm64_linux:       "331b84c075abedcf68bc225d78d15f57b342895f45f16bf3e9f48ff2fa5be090"
    sha256 cellar: :any, x86_64_linux:      "3d5f1c276c95c8e882b17f8dd8f52369bbc9f6d55f41f969424fad0650661ad7"
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

  deny_network_access!

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

    ENV.prepend_path "PKG_CONFIG_PATH", dep("icu4c").opt_lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs gspell-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    ENV["G_DEBUG"] = "fatal-warnings"

    # This test will fail intentionally when iso-codes gets updated.
    # Resolve by increasing the `revision` on this formula.
    system "./test"
  end
end
