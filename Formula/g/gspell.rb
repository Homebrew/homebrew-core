class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.0.tar.xz"
  sha256 "64ea1d8e9edc1c25b45a920e80daf67559d1866ffcd7f8432fecfea6d0fe8897"
  license "LGPL-2.1-or-later"
  revision 3

  bottle do
    sha256 arm64_sequoia: "7be7549f59cefa28a9820aa692e61beae5ac3907c00f405312ecd18ed13f657c"
    sha256 arm64_sonoma:  "956f9e9bba4d346b611b2ace7494592c26b764073c6063e453facb94973ecb12"
    sha256 arm64_ventura: "ae7078de1e4777703851e5f72fe339feb3306b55c93ddd5446da1aac4c0fe6b8"
    sha256 sonoma:        "7f0f171e26e6a956b23b54bcfdb47665a763999ac1dade0011899664aafc977f"
    sha256 ventura:       "2dec4a4e7abf1ccd9564cc91b1259a0896f854f809d5cb0271982a77e4b83050"
    sha256 arm64_linux:   "74ee2677d98ec0caffe66e3989f73977065f2d2ae6ae198c36a2f535bd31ef20"
    sha256 x86_64_linux:  "65b869605e06e7571c5e74776a815949afa4acf36185a0fee15c008db1979f60"
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
  depends_on "icu4c@77"
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
