class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.3.tar.xz"
  sha256 "04c8a74625fec84267fdec40306afb4104bd332d85061e0d36d4ab0533adfa4a"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "5fdf0e8f856b2937f7425adf1f76476a1c0c3040ae8cc19202ece4061f9e4003"
    sha256 arm64_sonoma:  "3e315618dbfccb93103370898a2893f577200c18fb06b78a91de4d63eb7e621f"
    sha256 arm64_ventura: "60d733ba2a88e1602239d9876d4544551514a2964132261fd3f20162f7cd606c"
    sha256 sonoma:        "0323ebe54212e9a7ed78feac735f3efd2e8f7288cbd8b9431a280482836a6935"
    sha256 ventura:       "1fac86edb73d530583e08a3df8a2fc8be8be38694a26cb26a0529483ef1b9b6f"
    sha256 x86_64_linux:  "8dc9764c957dba2820dafc9d46b6651f12f471b137ff31380782461694cac58f"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["desktop-file-utils"].opt_bin}/update-desktop-database", "#{HOMEBREW_PREFIX}/share/applications"
  end

  test do
    # Fails in Linux CI with: Gtk-WARNING **: 13:08:32.713: Failed to open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"file-roller", "--help"
  end
end
