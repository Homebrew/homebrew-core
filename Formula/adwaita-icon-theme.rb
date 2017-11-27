class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.26/adwaita-icon-theme-3.26.1.tar.xz"
  sha256 "28ba7392c7761996efd780779167ea6c940eedfb1bf37cfe9bccb7021f54d79d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3faf853054763bb16197e265ad82f59787bc2c4be91587ee2fb09b90df32b6ae" => :high_sierra
    sha256 "c49c2ca865f5d376f46be552bfb549fe270a083ad5b73e744b2771a8cf8514d4" => :sierra
    sha256 "c49c2ca865f5d376f46be552bfb549fe270a083ad5b73e744b2771a8cf8514d4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "gtk+3" => :build # for gtk3-update-icon-cache
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
    assert_predicate share/"icons/Adwaita/96x96/status/weather-storm-symbolic.symbolic.png", :exist?
    assert_predicate share/"icons/Adwaita/index.theme", :exist?
  end
end
