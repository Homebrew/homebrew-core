class LibspellingAT02 < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.2.1/libspelling-0.2.1.tar.bz2"
  sha256 "5393a9b93fda445598348a47c42d1ad13586c0bcf35dfd257afd613fd31812c1"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2743f798c8a8ab3afa19842bdddb996e868736ec1d95b324e18994b987625773"
    sha256 cellar: :any, arm64_sonoma:  "87bcb552532a3c890664a0b16a858ff766f49fc595ced5b8a5c387da2e3c4ce3"
    sha256 cellar: :any, arm64_ventura: "3fd146874edb16cefef9b8b2288fdcfbe0ef6811ee8e2d87635e6eb13acb2eb2"
    sha256 cellar: :any, sonoma:        "00d924b8e7f5cd27fbbe087e60a343c5a10617ac99d3605340eac21d0e31c171"
    sha256 cellar: :any, ventura:       "611812775575e4302a6612301a51d6036dc14dbbd4c031d848446e89219f08c5"
    sha256               arm64_linux:   "40fee8eb0750567f7e799007e4961a924b9139d469a65608528a7a1396392698"
    sha256               x86_64_linux:  "624143b2d621071b4239dbdf74b9adde6f7da4a8cbc42742bdee7435fd187749"
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
  depends_on "icu4c@77"
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
