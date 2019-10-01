class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.34/adwaita-icon-theme-3.34.0.tar.xz"
  sha256 "40b7e91f8263552b64d0f9beff33150291b086618ce498c71bf10035e48c7c7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f976bfb6dce673b6981c6d6ee0d563f99aafe3480f250a7f8676872297c24d74" => :catalina
    sha256 "83bc78c3c946ba7ebd78d4bbe43087efa1c3c21d773d43507685779f87876935" => :mojave
    sha256 "ade225cb36a388f23c5bf856aadd96a5c599caa0f84af7522f13afa909832b3a" => :high_sierra
    sha256 "3d0711c8b0772ce382ce8e13bef7f5ac248e0c3aa5d9b6742f741fb905f57f57" => :sierra
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
