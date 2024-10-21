class LibspellingAT02 < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/GNOME/libspelling"
  url "https://gitlab.gnome.org/GNOME/libspelling/-/archive/0.2.1/libspelling-0.2.1.tar.bz2"
  sha256 "5393a9b93fda445598348a47c42d1ad13586c0bcf35dfd257afd613fd31812c1"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c1936dea7e24ec7f2df1f1fbfb3723ad01b76777ea758c907eb343ec8b6cd9c7"
    sha256 cellar: :any, arm64_sonoma:  "eba6e2cde91f01fcd798d1fb5616e7b3ed5339c47757042df5e0ac9b79f0e4ed"
    sha256 cellar: :any, arm64_ventura: "ec0050d13a32dd4fbb40b947fb6e2ad57b85684fab90a678b36d525844b1220d"
    sha256 cellar: :any, sonoma:        "c57a664e8e205f97e7eaab2e256291809e7c84b7bd25a519f4161da3a8725fbc"
    sha256 cellar: :any, ventura:       "ad27fc3dae6f6886eeb12453ba7f3a07e2877ca5ccec7cb57f69e4bafdbeedaa"
    sha256               x86_64_linux:  "81033ad6a55589c5afd8102fc146ac68bf648be05b9773f4fd438184e3d18b22"
  end

  keg_only :versioned_formula

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

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    pkg_config_cflags = shell_output("pkg-config --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
