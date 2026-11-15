class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.11/libspelling-0.4.11.tar.bz2"
  sha256 "304ff82faaeb0ba131765a819f2db8ba5655bdbadc78fea64c12033274acebec"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256               arm64_golden_gate: "7ee514eeebb10157850cd04be5156b6fc51e29cef0a883f5e7589337b9e00efa"
    sha256               arm64_tahoe:       "834242b29b778542bf45c68fc0e9e52f5083d39d116e0a69a3c12a507b5a9896"
    sha256               arm64_sequoia:     "602be0b10d2e3fc888db00eb7d315df05585399ed9671b0812500c4f7d2341da"
    sha256 cellar: :any, arm64_linux:       "553b79de5ee13d5689e3a7ef17693b06172b8e71860ce35a09cd649b21738b57"
    sha256 cellar: :any, x86_64_linux:      "dca2abf8ddec5f34bb1f10f7e3553d08be4b29f773e501499f7611cba14a1152"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "icu4c@79"
  depends_on "pango"

  on_macos do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "graphene"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "sysprof"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=false", "-Dsysprof=#{OS.linux?}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libspelling.h>

      int main(int argc, char *argv[]) {
        SpellingChecker *checker = spelling_checker_get_default();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
