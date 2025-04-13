class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.7/libspelling-0.4.7.tar.bz2"
  sha256 "96fc2b1ae447536e00a6231541bb177a08fda6f30fdfeae68a0622040d82d827"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "e6d352bfa8bed2dcb29858fe12a46328a6dc589a4ff904c511ac7141f83404f9"
    sha256 arm64_sonoma:  "58e4a3c76190f3e9b9d2db63fa8b6161a963bed2b16468086f43a3b45b457bfd"
    sha256 arm64_ventura: "22728cacd4f060f5df5ed559c297bf08f64648e3a4ee9986050751cd6ad6bb5b"
    sha256 sonoma:        "599bf4f22144b2fdb5a9f215a9f5d9429aa3b02564cdf207246d8c7534e17d53"
    sha256 ventura:       "49aa7f47a6bcb8b1bd45cef872899aec684a8e505ce4d134978e5ab0056d5487"
    sha256 arm64_linux:   "62424b639296c25043ce89525535a8526c027ad05314d7321051052ab29091bf"
    sha256 x86_64_linux:  "55c177d5cafadd369d440cc514538a83e1832fc3fddc71803706daecbb2aa203"
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
