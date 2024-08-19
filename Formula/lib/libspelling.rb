class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.2.1/libspelling-0.2.1.tar.bz2"
  sha256 "5393a9b93fda445598348a47c42d1ad13586c0bcf35dfd257afd613fd31812c1"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0b67d9b2b9d9b93e5a71cd91c413444c656e8a30f6477f18f4386bdf30fb9187"
    sha256 cellar: :any, arm64_ventura:  "b66212b63da3b6f4b08f43c0aa91867c6519264bfef080a64213397910f457b4"
    sha256 cellar: :any, arm64_monterey: "fa750d80d38e7dcf30ec59ffaf63e0fbe2d13f0586c28732072e5b1a6836a663"
    sha256 cellar: :any, sonoma:         "53c748d558f513ad1e98da4c6f956fb39421e51c6d35503b4ab2b6b5bccace15"
    sha256 cellar: :any, ventura:        "82747b3e4fd94dd53bc8a7bde8487bee99bd86252e58a014b10878389fcfa65e"
    sha256 cellar: :any, monterey:       "c5cff6a0fc0b2ddc1a75e04f4ed0cc3197f571b80170522383b6fdf3d60577a6"
    sha256               x86_64_linux:   "59f65192b18ebed20951c1aae5af463dec1206eef1bc4779114f5bf06c01d785"
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
  depends_on "icu4c"
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
