class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.6.tar.xz"
  sha256 "9e873b5005bc425799a8cd4b237e1fff430ec8d6b34a992c6033f1dfc6e3764e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "95587f5b3683fe7adedfbeb595298ad7523a2d49f42c56afcf197f8d5d0abd8f"
    sha256 arm64_sequoia: "85dcd5458ca17191e75fc28a1825f0dc85394ec6f69c831bf33b0dfe266578cf"
    sha256 arm64_sonoma:  "8900422edf3663ad4d46171c5b2cc9f0135aefd198bb8de4d860b277136858bf"
    sha256 sonoma:        "f7b65189d4a73f7e6301cd87cc6bbe9495992190d87fbdceed98241956516747"
    sha256 arm64_linux:   "772259e557db001964b5ff2cc5df3b041aba0df75f54e8a41d33c8c9251b4db2"
    sha256 x86_64_linux:  "babf70dc9b287f09aada756e1b44743e01c39e89137f3b66725e7cf3f1960a3a"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dpackagekit=false", "-Duse_native_appchooser=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
    system Formula["desktop-file-utils"].opt_bin/"update-desktop-database", HOMEBREW_PREFIX/"share/applications"
  end

  test do
    # Fails in Linux CI with: Gtk-WARNING **: 13:08:32.713: Failed to open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"file-roller", "--help"
  end
end
