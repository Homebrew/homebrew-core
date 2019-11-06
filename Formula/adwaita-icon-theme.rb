class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.34/adwaita-icon-theme-3.34.1.tar.xz"
  sha256 "774c589b1a7d65b3cd251b52812404357b17cc5b2eb0a1cc7ed0ffd5dbdbbe74"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9f84346fdd2eb9108bfdc0e1166fe01f246326dd97d5d1b9d80ca72df927fd4" => :catalina
    sha256 "e3709b78f5f1b1619edff687e63e13e16751a525e559360c3e5fd07662ae38ed" => :mojave
    sha256 "f0530fc11d3734910ea702d1ac08b09c4a648fd55b254fbd700911739ac0084d" => :high_sierra
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
