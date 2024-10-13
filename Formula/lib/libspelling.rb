class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.2.1/libspelling-0.2.1.tar.bz2"
  sha256 "5393a9b93fda445598348a47c42d1ad13586c0bcf35dfd257afd613fd31812c1"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "acdd32585f66bf2dcef0ef13c0166294ae3e8742eba12f88b4f8fcf78a9644e6"
    sha256 cellar: :any, arm64_sonoma:  "ca7f5c29c5ffca0ef01ca9d2488eb1749e21ce456593096b4b60431a66b1cbd2"
    sha256 cellar: :any, arm64_ventura: "c8487296937ad4d072c1728c97163c82247ee89f8caac40174518730b16826e4"
    sha256 cellar: :any, sonoma:        "36dc778f440851ade2fe2b56c494e7058f3804117b04edf0ba7fb5f29a05d034"
    sha256 cellar: :any, ventura:       "2f1018445dabc70101abef5a49e13b5e32c886f6d246f7788f651dad221cc4ab"
    sha256               x86_64_linux:  "4b771175ee3b8db56799e624bcdb8e077b14487bd97a98a6fb40ba2b644e178a"
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

  def install
    system "meson", "setup", "build", "-Ddocs=false", *std_meson_args
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
