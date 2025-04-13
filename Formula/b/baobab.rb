class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://apps.gnome.org/Baobab/"
  url "https://download.gnome.org/sources/baobab/48/baobab-48.0.tar.xz"
  sha256 "54592504d49d807f23591be7e7eef10c6c9dfcb7ac527b81c3acd58787b26fda"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "80378d77f74e4164ade7e7544e8b2e51aa3dc204919bff16427ae1a620f88d29"
    sha256 arm64_sonoma:  "f837bbc3a3f8d1185383d148a15899d3826addf90da09386213927ea6b9b694a"
    sha256 arm64_ventura: "47e23d24e4c49ba8f2c76242e4c2c390ae0b1e0b768bd54f92ed14cf79cc77ce"
    sha256 sonoma:        "f7b366f966ca320df98ced77afe68a69053c1e2ff0b2441d0b3f53899a5d9617"
    sha256 ventura:       "1f6c2a5c773468e35139918a620e569607566b10ec6ee066537eec7c1a78bc05"
    sha256 arm64_linux:   "3f39c11e4a91021ba34908f1c5ee64ef45ceb5ed39e26f914047fabc54293252"
    sha256 x86_64_linux:  "55ec8b4e2e83bfaf90340312772aae33aead8e268f68caab0a845af626e0a64c"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https://gitlab.gnome.org/GNOME/baobab/-/issues/122
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end
