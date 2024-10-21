class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.4/libspelling-0.4.4.tar.bz2"
  sha256 "9b2adc84b7cb964588ee55f70a8c61fea942f894a89f41af9a186c7b17abbc5a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "825adf50b71f9eb08eca5e8dc39ab73f8eb9488ec47814320e099a82e484d1ab"
    sha256 arm64_sonoma:  "0fd8a8a7298e347b829c7c2d39c48d1015cc28db6998f7866fe95edc49352e5d"
    sha256 arm64_ventura: "3d7d1e3535959f6dfc3b7d152420d32dfdb027c9dcd3f0a35d08a84abf773aa5"
    sha256 sonoma:        "1b6e9f3a70e713b807d10f7d151d7de82bbe34c513d61245b9ff0a46e9619f57"
    sha256 ventura:       "0576797ecbec53cb15df3379154ccfbf4b58e9bc53f778db3a851d22d126ac9e"
    sha256 x86_64_linux:  "607fe428c36b2facc670ef2bd01644a8b2e5db832a9bb6efb2c958e811f821e0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build

  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "icu4c@75"
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
    (testpath/"test.c").write <<~EOS
      #include <libspelling.h>

      int main(int argc, char *argv[]) {
        SpellingChecker *checker = spelling_checker_get_default();
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
