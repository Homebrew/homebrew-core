class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.32/adwaita-icon-theme-3.32.0.tar.xz"
  sha256 "698db6e407bb987baec736c6a30216dfc0317e3ca2403c7adf3a5aa46c193286"

  bottle do
    cellar :any_skip_relocation
    sha256 "50a30cbc9017985d9ca2ff7285a0da47563dd3be313ee6fd406c172305bf0d7c" => :mojave
    sha256 "11a39582ae7f7e34f0d9d3557e01553d967546b6cbb6c9913799352437c0dbbe" => :high_sierra
    sha256 "11a39582ae7f7e34f0d9d3557e01553d967546b6cbb6c9913799352437c0dbbe" => :sierra
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
