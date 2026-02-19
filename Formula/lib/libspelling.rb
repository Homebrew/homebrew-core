class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.10/libspelling-0.4.10.tar.bz2"
  sha256 "d6388f3dc207269743ec920b14bb3be55ab4bd97a18e167b52a09cec0554dc2b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "11153634aad81e3844d252f6d844a3959243360ff7a825594109d096512f6f97"
    sha256 arm64_sequoia: "dd99e06b697f6c662c7146fd88bf1901db26abeb029390609b3a65cb0e53831d"
    sha256 arm64_sonoma:  "f9cb94f36b4721f4ef8bd475783569a24140b41c2c96197bd68ba5bd145d4533"
    sha256 sonoma:        "b2f39ab29923d2773c74bc2065abf8cfbb517a7c5eb4f52057e21f141f194882"
    sha256 arm64_linux:   "6f9877ad8aa58cce8bfeb6c6cd4c7e7d0753afefcf3d428bd2a8d019f9c5180e"
    sha256 x86_64_linux:  "547925f26bc3a232e3774dd75c229b3b155691982c3db5a3e9082dc88791ed74"
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
