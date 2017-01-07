class GnomeIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.22/adwaita-icon-theme-3.22.0.tar.xz"
  sha256 "c18bf6e26087d9819a962c77288b291efab25d0419b73d909dd771716a45dcb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "f96dfec8ea9ff5e520bdac34bf3aed1128bc6fbbaa5170b3089a3e55a136250c" => :sierra
    sha256 "f96dfec8ea9ff5e520bdac34bf3aed1128bc6fbbaa5170b3089a3e55a136250c" => :el_capitan
    sha256 "f96dfec8ea9ff5e520bdac34bf3aed1128bc6fbbaa5170b3089a3e55a136250c" => :yosemite
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
