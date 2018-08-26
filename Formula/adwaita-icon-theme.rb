class AdwaitaIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.28/adwaita-icon-theme-3.28.0.tar.xz"
  sha256 "7aae8c1dffd6772fd1a21a3d365a0ea28b7c3988bdbbeafbf8742cda68242150"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "bc2fa968cd32ae60bbb49bad4e0e36f9c45257df63d2f77d6f6fe0bbd562e486" => :mojave
    sha256 "eee6a8e9b781d135bf5b71eb28d5a7e791a11b9a1ba3c0bec5fc273c06ea0b94" => :high_sierra
    sha256 "eee6a8e9b781d135bf5b71eb28d5a7e791a11b9a1ba3c0bec5fc273c06ea0b94" => :sierra
    sha256 "eee6a8e9b781d135bf5b71eb28d5a7e791a11b9a1ba3c0bec5fc273c06ea0b94" => :el_capitan
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
