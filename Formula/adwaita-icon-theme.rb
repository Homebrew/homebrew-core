class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.34/adwaita-icon-theme-3.34.0.tar.xz"
  sha256 "40b7e91f8263552b64d0f9beff33150291b086618ce498c71bf10035e48c7c7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "40bdecea5ba2547c6e1b18c002c55cb36929927bb292a1a0a2b118c1c518492a" => :mojave
    sha256 "40bdecea5ba2547c6e1b18c002c55cb36929927bb292a1a0a2b118c1c518492a" => :high_sierra
    sha256 "ad4655cc24902f9b0580cc20b96f7be5f0696ef6c4dfbf59d2c604e997c97dc3" => :sierra
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
