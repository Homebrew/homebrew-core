class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.tar.xz"
  sha256 "5b1c0e6a2e7de75392bd424550c1e5643dd1cf6c333fb1ed6a76419a29507aa4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "e31e3600ec422fd6fd0067abafbbe85cc9fd71e8591c4dcd32badcc216d789e1"
    sha256 arm64_ventura:  "cab0237602459e94c712ff47d0c63810b5fd551e0aa8b588957f9227f0d72df4"
    sha256 arm64_monterey: "53943b298cc30a05a3da112745c0d294a8cb30487092edc33242f07081071762"
    sha256 sonoma:         "d028f009ca3f7fd7704366d6e1d83dcd0a5f64c86bc1744af06c9e6280f35f96"
    sha256 ventura:        "a1904027b618e0b55707fb460ae83b889b3ed511ea6a454588b473497eca9e59"
    sha256 monterey:       "6aa1b1a570e0e790db69f9c5075049bb7207e30e816e4c5625fc8e0b55d39060"
    sha256 x86_64_linux:   "92d8ab339ba7dacc9f344e52f228518763a71c1fecc3709700342445c64830cd"
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
