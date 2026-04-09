class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/48/evince-48.1.tar.xz"
  sha256 "7d8b9a6fa3a05d3f5b9048859027688c73a788ff6e923bc3945126884943fa10"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3b7e9c903699d610e7e118ac6268b5f2b0dcbbadd553257be807aaca0b2ff4d9"
    sha256 arm64_sequoia: "c79bd492a970f0a2faaa173dd9129a9ddee30f3cb67f6700cce4564bdafe0b2a"
    sha256 arm64_sonoma:  "4146849007042d512b61feeb08fa4db530eeb43a55d4b7718b77ba477a2cd3c0"
    sha256 sonoma:        "3a2e85b4add1137e10a843ef53563a53ef6bbaf2d92b05223edfee1009880767"
    sha256 arm64_linux:   "9d5b11ec7436eec5ece2dfd76ddc9b912135f1b5f5c0493fb5aca1fad97a9e33"
    sha256 x86_64_linux:  "696a73056be75f55f4ebeb0ad5976bf7366cfebc128a13436a1a1d606354cd6d"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "pango"
  depends_on "poppler"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dps=enabled
      -Dtiff=enabled
      -Dxps=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Ddbus=false
      -Dgspell=enabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
