class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.2.tar.xz"
  sha256 "2c5717ce7f05fbab13c847b6ce31b1b0248861fa7ab8f0ff1f1e1d45d1e2cdf9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "d21a6d2b1ff63ce7822f451e0db2318e09941da98ae6e867fd9788caf3992691"
    sha256 arm64_ventura:  "670414096d4621b75a7d06db53b73a7384fd4a67cb4a578140045ffd7e5e2c88"
    sha256 arm64_monterey: "60f45c8d92850984d19cb6e40f9dcbf3db3e2673e5c94cebc77522ac600813c8"
    sha256 sonoma:         "b0e6ef51f3dd8279cc56b60937387a1d74c9d0acf0f5d225e8b4081eb68a8c34"
    sha256 ventura:        "2ca444a7c5c49555baa1d82e113dbfb309b8fef4150c564195b4fcaffbadfd2c"
    sha256 monterey:       "540c607497cd12b7493119d4b33737a1b6fa01d5d1a8604186da759dd737ae1f"
    sha256 x86_64_linux:   "f036cf4f8f59627165862078de20c332314bd794a1ae1c311e516364703f833e"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "libmagic"

  def install
    # Patch out gnome.post_install to avoid failing when unused commands are missing.
    # TODO: Remove when build no longer fails, which may be possible in following scenarios:
    # - gnome.post_install avoids failing on missing commands when `DESTDIR` is set
    # - gnome.post_install works with Homebrew's distribution of `gtk4`
    # - `file-roller` moves to `gtk4`
    inreplace "meson.build", /^gnome\.post_install\([^)]*\)$/, ""

    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dpackagekit=false", "-Duse_native_appchooser=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Fails in Linux CI with: Gtk-WARNING **: 13:08:32.713: Failed to open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"file-roller", "--help"
  end
end
