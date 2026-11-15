class Gspell < Formula
  desc "Flexible API to implement spellchecking in GTK+ applications"
  homepage "https://gitlab.gnome.org/GNOME/gspell"
  url "https://download.gnome.org/sources/gspell/1.14/gspell-1.14.5.tar.xz"
  sha256 "788783b56fc3d03283b3aa29302d0b958aeca88835e10b1ec61f19e0efc7e8a4"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256               arm64_golden_gate: "1825f93c9c2b5929c5e0bbc4848eb1895b3baffba84fa8f128509f90f2cb701a"
    sha256               arm64_tahoe:       "940d03396bb9d34e7753109c07ce18c4922ac42c974b55b159c43642c16256b8"
    sha256               arm64_sequoia:     "6df28d492beac4efcf539251afd028887f8e68bf1bce3792d22555aaeba0a241"
    sha256 cellar: :any, arm64_linux:       "74ee00300a2897d905b7b4b6a395de80036e60740a20da943a0f8d9604f505ee"
    sha256 cellar: :any, x86_64_linux:      "aa3f9766d6624c5a3891b0ebd32a474141b52a5470253ad7433d863b3c96a06f"
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
