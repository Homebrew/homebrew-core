class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://apps.gnome.org/Baobab/"
  url "https://download.gnome.org/sources/baobab/47/baobab-47.0.tar.xz"
  sha256 "b88f74f9c052d3c2388f7062d228cf5e927545acf7408c56841df80ccd1f9c37"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "12e11545d6f02d1a88483055e749bac19b045b156fd5ca7cae591e792e5e61dc"
    sha256 arm64_sonoma:  "38db124b08f97a3724fd1120e492d9c4d40e6a5c584cab7bdfab4847622167ab"
    sha256 arm64_ventura: "12d32bb8bdadbf48a6545deca728efd0bba40c89fe4ba67e327994190cc85c26"
    sha256 sonoma:        "b4df7f44d53e3d27f90505331a0410c9c2d353ad8e9c98425c4e9c41e28291eb"
    sha256 ventura:       "e7a371708e8a66aa9526089ec7a291f75fc9347658f2bf959a363ee467cc9829"
    sha256 x86_64_linux:  "ab089d8ad6d53915b1523b8cc93f2c50b09c60a8e8fe9da2b2285f175546a5c6"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
