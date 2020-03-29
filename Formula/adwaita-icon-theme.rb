class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.36/adwaita-icon-theme-3.36.0.tar.xz"
  sha256 "1a172112b6da482d3be3de6a0c1c1762886e61e12b4315ae1aae9b69da1ed518"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fdad64a1d6939479fbabd4bbbbd22edb6cffb166f11ffe3080bdeb56d57de73" => :catalina
    sha256 "7fdad64a1d6939479fbabd4bbbbd22edb6cffb166f11ffe3080bdeb56d57de73" => :mojave
    sha256 "7fdad64a1d6939479fbabd4bbbbd22edb6cffb166f11ffe3080bdeb56d57de73" => :high_sierra
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
