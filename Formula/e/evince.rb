class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/48/evince-48.1.tar.xz"
  sha256 "7d8b9a6fa3a05d3f5b9048859027688c73a788ff6e923bc3945126884943fa10"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "7368c3bba0d45b928b0899a929bbe2fab0c7cdf6a34cd83ef6cca5f45b8bf998"
    sha256 arm64_sequoia: "06518d30ac2a79a327ee013a5d966279b6749c6fa4bb41a85e0bb2cf9037563c"
    sha256 arm64_sonoma:  "9fdc7ef485f94104cd7e4339273a1be61f178861550d30f837f0882da0eaa344"
    sha256 sonoma:        "fba32bdcd8bc5948457dc8f3d493930baee6a8667eb03bc6eb81fb53943cc025"
    sha256 arm64_linux:   "c3b7ff3ce4eaa1abc6c75b1bbdfbd580e5ff9a293c9c9f970e4213ad97ff3e45"
    sha256 x86_64_linux:  "71fe8192226f74e9df97e95eca1292d0328729b530bff5ef1e61ec7cf66300d4"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build # for msgfmt
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
