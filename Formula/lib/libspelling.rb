class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.4.9/libspelling-0.4.9.tar.bz2"
  sha256 "e0f1785e3314bd081bd3da391547af741d4b313c655d5cf512e4ef1aee615997"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "bebedccb83fb042d25224aaf21137d07cfec6364c9505423afe3d980e1bd6eda"
    sha256 arm64_sequoia: "4a880aa0400ad1c137f5cf3c8169b5870c1198eba53bcaa42eebaf884c14cc36"
    sha256 arm64_sonoma:  "3d16b48b085c1ee327d83c5ed09e373eb0ce04874baf515d59b7f17c943eec1e"
    sha256 arm64_ventura: "02eba6554cff809702815658b608c9fc1231ace3f90d43b7827a029b0845aa3f"
    sha256 sonoma:        "6ac221fdeb025b196935a883143beb5b7fb643e9e630cf0c7dbacbf78a3c5ac7"
    sha256 ventura:       "94e0f296093b08efe25776dd5fc797453e87397941f388bccee13c125498e326"
    sha256 arm64_linux:   "c04adda1ccd39ab991eba2c7937620b89dd969a11b52fe4205315ee3250fd98d"
    sha256 x86_64_linux:  "6b4a43c001061665952d938bcfef8ab13c9bc944f00a9bc721b94641ee8ac6fb"
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
