class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.3.tar.xz"
  sha256 "04c8a74625fec84267fdec40306afb4104bd332d85061e0d36d4ab0533adfa4a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "60b36504d219e315c40a1d02a87695a9a7d07969af197c3828fcdfd6ccd9812c"
    sha256 arm64_ventura:  "115a0a2c78fa688329b1d84faa06859c174f56bead3f8028e4657ee442e11c63"
    sha256 arm64_monterey: "db73bc657ca7657bad19d95a662faa67314bcb27496abb6696168931f58f1663"
    sha256 sonoma:         "56aa134dc0e94fd4a5ef6f0a40bd52f5c7a7910f9eb4132d4217f3273295dc54"
    sha256 ventura:        "4c584885bf6027515a50a08c0bec615126612b8f42f2b46f2e941a1c0e49c33e"
    sha256 monterey:       "2d15c4f88082ca31090bfa71ed2fc15de4d8ac613c67e832741228da03c697e5"
    sha256 x86_64_linux:   "93441fcbc955bde70980558e9bafca1ee1808b688cebe7ae4bc024d73f4d0214"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

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
