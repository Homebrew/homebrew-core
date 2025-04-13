class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/48/adwaita-icon-theme-48.0.tar.xz"
  sha256 "847068888650d9673115be6dbf2bfdc31a46aebc528a6a9db4420e60e656b8d4"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e14b79a34a4434fee1b94788985410ede2fd9f93b00a7c62a800fde4dfb6b39a"
  end

  depends_on "gtk4" => :build # for gtk4-update-icon-cache
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "librsvg"

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
