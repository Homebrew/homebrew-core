class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/51/adwaita-icon-theme-51.0.tar.xz"
  sha256 "ba561cf3c96305a47179fa5605856ad695c9238ea07f7093aebd9ba80c4e323b"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f40942bda19569a8dfc6b9c89c2fc7b7e1d89231fa2f0e0478166b08a91b23fa"
  end

  depends_on "gtk4" => :build # for gtk4-update-icon-cache
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "librsvg"

  deny_network_access!

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # This checks that a -symbolic png file generated from svg exists
    # and that a file created late in the install process exists.
    # Someone who understands GTK4 could probably write better tests that
    # check if GTK4 can find the icons.
    png = "audio-headphones.png"
    assert_path_exists share/"icons/Adwaita/16x16/devices/#{png}"
    assert_path_exists share/"icons/Adwaita/index.theme"
  end
end
