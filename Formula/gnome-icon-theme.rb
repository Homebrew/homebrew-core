class GnomeIconTheme < Formula
  desc "Icons for the GNOME project"
  homepage "https://developer.gnome.org"
  url "https://download.gnome.org/sources/adwaita-icon-theme/3.24/adwaita-icon-theme-3.24.0.tar.xz"
  sha256 "ccf79ff3bd340254737ce4d28b87f0ccee4b3358cd3cd5cd11dc7b42f41b272a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c0129752f29ddbdaf32f5517fbeb9fd76b8bc0a82ddb5f2b270544c3ed33ea9" => :sierra
    sha256 "8c0129752f29ddbdaf32f5517fbeb9fd76b8bc0a82ddb5f2b270544c3ed33ea9" => :el_capitan
    sha256 "8c0129752f29ddbdaf32f5517fbeb9fd76b8bc0a82ddb5f2b270544c3ed33ea9" => :yosemite
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
