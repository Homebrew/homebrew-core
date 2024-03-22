class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://wiki.gnome.org/Apps/Baobab"
  url "https://download.gnome.org/sources/baobab/46/baobab-46.0.tar.xz"
  sha256 "ce4def5c82d05671a5009f7bebcf85ac98675d9d8160d28ad9181b269a72e37c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "b2b03a56d8ac4a7499d8bcc100d66a3898898d89d5b43b0ff0838096774eb941"
    sha256 arm64_ventura:  "36fa0972f41310643be85354a2a098e73713aaf27521a29982c899a9e12bafc1"
    sha256 arm64_monterey: "da943150c400c94b10d540d494aa40569523b1afb25ed30a53efa7b8ca61c4a2"
    sha256 sonoma:         "998e2590ecc63ffd66624d49ddb1d206be2e5cc1a5c049234779b2e0f1e41caf"
    sha256 ventura:        "9bf97e0440388cfbd896fb6eb41a7adfeea17d29593cca2f23849f71289a5c8b"
    sha256 monterey:       "396e9b0686844b2d7ab83c12a87155f3cdbf4691fa42f91b1bf6ce4eeffd6102"
    sha256 x86_64_linux:   "dd385933494b6cb5e6a6b0b911c83f4c6cf9922d8a17830d61cca27d763cf659"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"

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
