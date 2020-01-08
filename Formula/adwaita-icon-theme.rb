class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.34/adwaita-icon-theme-3.34.3.tar.xz"
  sha256 "e7c2d8c259125d5f35ec09522b88c8fe7ecf625224ab0811213ef0a95d90b908"

  bottle do
    cellar :any_skip_relocation
    sha256 "23ef97afb525a9e4bdaea64784b3ede7768cb6bdbbbcd499cfcbb6142f135bb0" => :catalina
    sha256 "2c619eb38181590fd489152251eb53996473767acea86ed8ae75b34e19616b90" => :mojave
    sha256 "8db6e7041b597d0b36b664fe9330cbb3cb09a5f9a3f253cd92be88c045eefb68" => :high_sierra
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
