class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.1.tar.xz"
  sha256 "250cf551cfcb12a670ca8adf953e0681f1c9b76ee09d9458b20203c62602c487"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "bdb3ad526e6181e53ba5ec77a68a1f10891f0956f11058a48ec67ba92d949d88"
    sha256 arm64_ventura:  "88a963b595a6b12fe6555af2093747c8873ce9d099df3a4ae2b6da922b05de75"
    sha256 arm64_monterey: "69bee0c4657e5ff50463024ee0e2f836e5093b65c845a738339527bcb395a33b"
    sha256 sonoma:         "6cf8f0e86a3c046aa6604616e70f7dc88fd9b11fd91dcfd586eee1b63a879bfd"
    sha256 ventura:        "30ccb91666291f330248e0f1bc8258d01a30e3e2c0687f9680def9589b7c4fef"
    sha256 monterey:       "ed667e36a92ff470351c3ea782a288d55ddd2d289f582f7f54c047be6688ec80"
    sha256 x86_64_linux:   "5a201002563516c566f398e0a44fe6a1377de4f5eabd986bc776219ef5f48c36"
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
