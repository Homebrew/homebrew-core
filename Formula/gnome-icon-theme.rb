class GnomeIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.22/adwaita-icon-theme-3.22.0.tar.xz"
  sha256 "c18bf6e26087d9819a962c77288b291efab25d0419b73d909dd771716a45dcb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d69343d2503ebe9be432c7e72bcffb8ea23373691b07daf1352e02806901676" => :sierra
    sha256 "a142df8966a20f3fcb822e6f0d1c22bb05e0853d868a4e333c7d7051dcfbb08e" => :el_capitan
    sha256 "1400ab040506ae631f75ccfd97bb73237fea4bc42afe6cda630ee62f7eed0602" => :yosemite
    sha256 "1069597c5927c5370a589ae96b1ec5378f87f739413430d164bacaf5a00c53a6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "gtk+3" => :build # for gtk3-update-icon-cache
  depends_on "icon-naming-utils" => :build
  depends_on "intltool" => :build
  depends_on "librsvg" => :build

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
    assert (share/"icons/Adwaita/96x96/status/weather-storm-symbolic.symbolic.png").exist?
    assert (share/"icons/Adwaita/index.theme").exist?
  end
end
