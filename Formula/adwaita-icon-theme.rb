class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/40/adwaita-icon-theme-40.1.1.tar.xz"
  sha256 "0b6c436ed6ad9887a88ada1f72a0197b1eb73b020d8d344abab4c7fa7250f8f6"
  license any_of: ["LGPL-3.0-or-later", "CC-BY-SA-3.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d32ff160b977a5f9f37d096199199e3503bfa73c19556ec1260559f1af48def"
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
