class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.30/adwaita-icon-theme-3.30.1.tar.xz"
  sha256 "6d752a2b1bc668483956d4485c39cad1642d9358e133ff689526e43674a4e1ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "f83ab9e3d605ad4f8598f1321318a95120887481fdabd5ec0a543fb265c4fdf9" => :mojave
    sha256 "15085020944f26d8572772fc1f28566e2f85b0bb81b99dd688a8200b2ef5c758" => :high_sierra
    sha256 "15085020944f26d8572772fc1f28566e2f85b0bb81b99dd688a8200b2ef5c758" => :sierra
    sha256 "15085020944f26d8572772fc1f28566e2f85b0bb81b99dd688a8200b2ef5c758" => :el_capitan
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
