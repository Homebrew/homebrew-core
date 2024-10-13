class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/46/ghex-46.0.tar.xz"
  sha256 "a1c46f3020cb358b8323025db3a539c97d994a4c46f701f48edc6357f7fbcbd1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "0b7bdd05fff50a48e6f55287c17557c428d11c8111995a4d16aee7fe2683f4aa"
    sha256 arm64_sonoma:   "9f4e0ef2491956e6ab73d699d2eb62c8e1e99fd0ba8559670d1effa005c901c4"
    sha256 arm64_ventura:  "377d24393d5492f132cef436b302b43d6ec8d88324934fe8da2e3f3bbf0fdefa"
    sha256 arm64_monterey: "50861d574cbbfee6159eb9727fd85491c68220876d5fad8657838a2bc09e15ee"
    sha256 sonoma:         "3f646f8e3d4c910ca0bfcf9378e4714b83305a0240cb5c94ee9042a970e986b9"
    sha256 ventura:        "df165bcd79ab7c61eb9d9309d5ac1f4210defbeb9366a5446ccd8cd77b956f3a"
    sha256 monterey:       "bd928e90b41850305eada276227355bd89257e9c401dbff564dcb865e587fecc"
    sha256 x86_64_linux:   "7634934203285fc6da5e3c7f08957c9d7c7c6cee162178dcdca920de417ae2bd"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # (process:30744): Gtk-WARNING **: 06:38:39.728: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"ghex", "--help"
  end
end
