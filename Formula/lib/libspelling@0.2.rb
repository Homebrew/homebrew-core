class LibspellingAT02 < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.2.1/libspelling-0.2.1.tar.bz2"
  sha256 "5393a9b93fda445598348a47c42d1ad13586c0bcf35dfd257afd613fd31812c1"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "4aa8612cf0ccef0652272022d796b87a0fd9bd52a32829a258f7b84566cd57df"
    sha256 cellar: :any, arm64_sequoia: "c2ee5198fcc027b5301c70b7aaee4f80f8ce6382e95e926fb525a67116532530"
    sha256 cellar: :any, arm64_sonoma:  "580a1509f154fb6986d09e643178e6fd8f92d29097371255d77efef147a2ae93"
    sha256 cellar: :any, sonoma:        "a85f5638ccb202ba93ba3ecc0b7fba612b326b91771bcb13ccc7edd84e14d81a"
    sha256               arm64_linux:   "bd8174c6c8fbea8cb4c22b7c117be85bbf36c071650a6753328dabf660ccc8c6"
    sha256               x86_64_linux:  "906be58f7a2dd7c8c014cd968f82253808ab3c3d777c7104f647d30b5dac8b51"
  end

  keg_only :versioned_formula

  deprecate! date: "2025-01-11", because: :versioned_formula
  disable! date: "2026-01-11", because: :versioned_formula

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
