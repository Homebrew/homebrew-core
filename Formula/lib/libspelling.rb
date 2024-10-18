class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.4/libspelling-0.4.4.tar.bz2"
  sha256 "9b2adc84b7cb964588ee55f70a8c61fea942f894a89f41af9a186c7b17abbc5a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ac974925bc8a42dd8d2e392fa97a0227d36b48cca4222fa12ef7a4201adb9ef5"
    sha256 cellar: :any, arm64_sonoma:  "f2db6aa552c66755856592eb4f9e1b92f5ba1ddbe932b5e0be90228a548e08b2"
    sha256 cellar: :any, arm64_ventura: "2c1aacb307912ea28b66fc20811b01bb5bdccaef985e4088fe4efc3b79f71660"
    sha256 cellar: :any, sonoma:        "b99be06b6c63c2dc2a8051357114618a1e0fc92d201adf0f3cae429631942386"
    sha256 cellar: :any, ventura:       "e2e8eb2eeed7a763732f3c2aa30aef908699f4c75d73409c284ae77af1deb8d6"
    sha256               x86_64_linux:  "0f450f031675de0f0e1253c7122a48618e1b5e56806dfc01f699d9cd5a11853c"
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
