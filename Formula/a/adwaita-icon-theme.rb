class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/46/adwaita-icon-theme-46.2.tar.xz"
  sha256 "beb126b9429339ba762e0818d5e73b2c46f444975bf80076366eae2d0f96b5cb"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3d359d575a07d463dae85557e6d348fe19bec5afb3c9b427ae6b331969b80dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3d359d575a07d463dae85557e6d348fe19bec5afb3c9b427ae6b331969b80dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d359d575a07d463dae85557e6d348fe19bec5afb3c9b427ae6b331969b80dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3d359d575a07d463dae85557e6d348fe19bec5afb3c9b427ae6b331969b80dc"
    sha256 cellar: :any_skip_relocation, ventura:        "b3d359d575a07d463dae85557e6d348fe19bec5afb3c9b427ae6b331969b80dc"
    sha256 cellar: :any_skip_relocation, monterey:       "b3d359d575a07d463dae85557e6d348fe19bec5afb3c9b427ae6b331969b80dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d460a6991524bce66ca08453f5acaaf2529bfe00f18871f2bd95b47d3520efc1"
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
