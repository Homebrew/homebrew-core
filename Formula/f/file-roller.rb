class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.5.tar.xz"
  sha256 "dfaf4bb989c0b8986be8bdae9fffeab8d0f30669ae3a627e8c3df94f23888339"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "f756166e2f8d8a1ad326aecb762ea4f2723391b71f157933d52d5fc8ae563abc"
    sha256 arm64_sonoma:  "08c5b181ebd6c9dd5861090faac091abd07f36199a48594c8a33a584f2fef547"
    sha256 arm64_ventura: "5ec67bc1f0665499393b1420fd5070bc57e0059e5c04d044997655d4a2315c28"
    sha256 sonoma:        "ce2ab247a858cab6c68b0cd626711702c071f92d1d3b8c5243cf1053f1198e86"
    sha256 ventura:       "57949c05dd19d84cdf4f282b613f038bdb7014f8f727ce5d1e93a9459158f5f3"
    sha256 arm64_linux:   "f47f16d1ace2fae5b1413dcbe014539ab63ec30f7d985c616f55d4047fb79103"
    sha256 x86_64_linux:  "e8676370725168f275649203d897d680f1fb005d74d1590601a47bb59a52c343"
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
