class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/47/adwaita-icon-theme-47.0.tar.xz"
  sha256 "ad088a22958cb8469e41d9f1bba0efb27e586a2102213cd89cc26db2e002bdfe"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02a59c3c9335a81374805e6959a572255f6def77b599ee378ad39a1fe6ff61e7"
  end

  depends_on "gtk4" => :build # for gtk4-update-icon-cache
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
