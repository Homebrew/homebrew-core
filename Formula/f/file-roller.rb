class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.4.tar.xz"
  sha256 "b8c309da3aa784c719558c3466402378f4a3d6cae8ed77cf6849aacd56ceb9ec"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "58dcfb00dadd8c98610a6d536f54abf6ae29422a50a258619369f2dce79a4c88"
    sha256 arm64_sonoma:  "23a0cf73bd4e04a939632f18e133c6c45d65d932ffd52c465985a3677eb19cf1"
    sha256 arm64_ventura: "a96c174f776fac26bf71fef578fd611501c8942035cc837cbf05719a3d0279eb"
    sha256 sonoma:        "0fa0c7d4f29a9303897a1c01ef01ba04b949356495ad06dcb5f19dbb10123ce6"
    sha256 ventura:       "695c4c4d1bebf33c0e99ddf5e5a521bcc840755dc6cf5c412fc8e61384ffdad5"
    sha256 x86_64_linux:  "bef062dad4c6d4dceef22c1441dee977e4cfda91825408facb410633c5774e46"
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
