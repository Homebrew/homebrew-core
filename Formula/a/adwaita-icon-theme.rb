class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/45/adwaita-icon-theme-45.0.tar.xz"
  sha256 "2442bfb06f4e6cc95bf6e2682fdff98fa5eddc688751b9d6215c623cb4e42ff1"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f15f403be112f15296ba0526f19abbdcbb830ca027cec557ef52c1f3563de05"
  end

  depends_on "gettext" => :build
  depends_on "gtk4" => :build # for gtk4-update-icon-cache
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
    assert_predicate share/"icons/Adwaita/16x16/devices/#{png}", :exist?
    assert_predicate share/"icons/Adwaita/index.theme", :exist?
  end
end
