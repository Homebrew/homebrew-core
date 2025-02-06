class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.6/libspelling-0.4.6.tar.bz2"
  sha256 "5625bbb3db35e8163c71c66ae29308244543316d0aeb8489d942fab9afd9222d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "d56030a9c7df0a6df906f7968a6dddd1e9c780fec38d8342fa494bf964732c14"
    sha256 arm64_sonoma:  "517e048a0a042c793b29b11a800b73b6da5cb5aa6e66c16f289803429121dcbd"
    sha256 arm64_ventura: "fab7ad25343dbae5c38502466e58630787440ee1b8c80767da0c663aadd852ef"
    sha256 sonoma:        "9ce0b5fbdcb283c2088ba270a72a73f6ad07b05660cba58a1aa7740f1d6ef039"
    sha256 ventura:       "ebbcd4610964540e55a939258ab130f899925249699e956b5d17ec6f38d77119"
    sha256 x86_64_linux:  "86c87524dd02462c5e0f0e26e02f3145acfcdb51f8548274e86698b75df7b834"
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
