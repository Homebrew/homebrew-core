class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/40/adwaita-icon-theme-40.1.tar.xz"
  sha256 "3fba2ee1e9e2225413230397824fc9d484271c44252db7f57ba9bebf45c9b12a"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63c2d3f52b20c2232c73d97341e2b8c3e45903a95ee0a0ad46fce22759ed9cd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6a70379a4b6229960f08e4116b95c9b4ed6c21be10cadb22d9196600a04bc4b"
    sha256 cellar: :any_skip_relocation, catalina:      "a6a70379a4b6229960f08e4116b95c9b4ed6c21be10cadb22d9196600a04bc4b"
    sha256 cellar: :any_skip_relocation, mojave:        "538d43c64f03df2f26be1b5634a8f2411687d83fc8ff06942d3ced624970c91d"
  end

  depends_on "gettext" => :build
  depends_on "gtk+3" => :build # for gtk3-update-icon-cache
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "librsvg"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "GTK_UPDATE_ICON_CACHE=#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache"
    system "make", "install"
  end

  test do
    # This checks that a -symbolic png file generated from svg exists
    # and that a file created late in the install process exists.
    # Someone who understands GTK+3 could probably write better tests that
    # check if GTK+3 can find the icons.
    png = "weather-storm-symbolic.symbolic.png"
    assert_predicate share/"icons/Adwaita/96x96/status/#{png}", :exist?
    assert_predicate share/"icons/Adwaita/index.theme", :exist?
  end
end
