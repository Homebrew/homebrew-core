class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.9/libspelling-0.4.9.tar.bz2"
  sha256 "e0f1785e3314bd081bd3da391547af741d4b313c655d5cf512e4ef1aee615997"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "82fb463faf73331e5efc24529bb3d9b95f764782ca8ec4bbd9e1a3e94261dae6"
    sha256 arm64_sequoia: "ed3c16c67afa11b0e4a58f14b38699247642d2147f1c47839035d159eb4f3399"
    sha256 arm64_sonoma:  "3d6a6e816c163f78be811b0771b0b15b0e0aec76949dc41f6a21c9cb70c764e0"
    sha256 sonoma:        "67ce6630b65a1d008909c63d26211a87f886c1765cf4a187d7d25216ac324572"
    sha256 arm64_linux:   "2e6b11ad8ea4ea589d7a248f23acae67d35f28dd0ef3742ec0037499c564a8ba"
    sha256 x86_64_linux:  "b039e443ee31e1f5706c6c8b504b1225821f4367d6d7aa4a9ba3cd079d222842"
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
  depends_on "icu4c@78"
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
