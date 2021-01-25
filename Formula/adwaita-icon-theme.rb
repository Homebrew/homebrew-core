class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.38/adwaita-icon-theme-3.38.0.tar.xz"
  sha256 "6683a1aaf2430ccd9ea638dd4bfe1002bc92b412050c3dba20e480f979faaf97"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d92b1254bb3b7f6f85d85349467a38034fab55022bab0ca74fbc4318638124f1" => :big_sur
    sha256 "3ada93f56a15c30f84f71037f769e21b506a11de01d8bc1d4d2c147be38851ff" => :arm64_big_sur
    sha256 "dece11e0f852fe42fc3d201caed23435be5a762ccabe0f4c539022aeb7104f63" => :catalina
    sha256 "02bcde4cd5cc560a5ed65090904b7cd64bf334c06f77bbd351bf7cb77e33240d" => :mojave
    sha256 "09957230244ec34e451a2d54e8a37875372afe74a3f9f7512b2c50eaccc5eff5" => :high_sierra
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
