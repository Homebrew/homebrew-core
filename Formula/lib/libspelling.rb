class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.8/libspelling-0.4.8.tar.bz2"
  sha256 "dadd7bfc58511b85f966570b6f241ae1c695986746daa634de4a2d856886ae18"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "fbe0fcc807920d739d6b3b0afd3112b3a630e9c16901bf26d6e98534a142635e"
    sha256 arm64_sonoma:  "9b31165f047196455a03540f285194ca480c092911a989fdb340c1d72d19767b"
    sha256 arm64_ventura: "d97661610524135c0a5e23ab946808993d381ca57e4d476d149b7913a2157659"
    sha256 sonoma:        "13105682dc441454d57022ce6bd4940fc74eca98f945da256c4bf09187917883"
    sha256 ventura:       "3e5a4bd47a10a9e420a7ec1fdc748267f92f39d4018088833bbd661f99955a75"
    sha256 arm64_linux:   "6f4fc941b83f8f5a99a14bb7e1777087ebcf90fc35cd5c7c24ddbb41b50e43b7"
    sha256 x86_64_linux:  "2e9d4e21d39f5c8ae6d02a0e0897896dd2edf618561c85a30409fdcab7ed0bde"
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
  depends_on "icu4c@77"
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
