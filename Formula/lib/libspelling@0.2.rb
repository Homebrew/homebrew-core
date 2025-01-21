class LibspellingAT02 < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.2.1/libspelling-0.2.1.tar.bz2"
  sha256 "5393a9b93fda445598348a47c42d1ad13586c0bcf35dfd257afd613fd31812c1"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2cd2a76ecb4d0c55efe4f3ad8f58bc8a6a8c077bc453ef004f0285aa071a24a2"
    sha256 cellar: :any, arm64_sonoma:  "b652f34c8392f88a799e5285224b9af15781c556b4badd43b93d0689e55e91cb"
    sha256 cellar: :any, arm64_ventura: "9bac22470da786b43ab4cee4811ec97315593e6ca65a845cb50ceab4cbcdae2e"
    sha256 cellar: :any, sonoma:        "b9696d798a8832c3ecf34dd3cac5f7213b830e6f37ce80bb2013a44449673b3d"
    sha256 cellar: :any, ventura:       "6d90b748623f6bca87717ef60777ac623a3a12478c234af42acb24c44b116ed7"
    sha256               x86_64_linux:  "524fb06ad25e8e6a8ca34c3cdde8a9089557b17bac93039aeefb3f357cd0c5fa"
  end

  keg_only :versioned_formula

  deprecate! date: "2025-01-11", because: :versioned_formula

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

  def install
    system "meson", "setup", "build", "-Ddocs=false", *std_meson_args
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

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
