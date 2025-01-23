class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.5/libspelling-0.4.5.tar.bz2"
  sha256 "d54c0b5e5f176b75bdb57640e13214c92b188995c5333fec798be65603d7cad7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "85a6b4841512a5ce08e359110ce16767f5d936cdb98648d746a5474e2f9ca87a"
    sha256 arm64_sonoma:  "d729a17269dc05233680f3f668961c8ac4592bcd38c649c1c7d5eab76d1e8b71"
    sha256 arm64_ventura: "dbddfbcb42507dfe3f2f37acd4293652b60010cf64a853a7e6a26737e4a00af1"
    sha256 sonoma:        "211dc82ec83b0a6769b3fa7d443d99f347ab0cf970235f6a8b35612fbe6cd2d7"
    sha256 ventura:       "3407b8d7874a64ebb9833aa69a867e9952b68867d7e8b855a796b9408d502ab4"
    sha256 x86_64_linux:  "6342666f2d5291249bf0df5f42daa56d4a4790b9f5c329fc38be04827fc8df4f"
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
  depends_on "icu4c@76"
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
