class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/48/evince-48.0.tar.xz"
  sha256 "cd2f658355fa9075fdf9e5b44aa0af3a7e0928c55614eb1042b36176cf451126"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "daf7885b9cbb982b49f4a39c31568ff4cdee5e9743e9aa387def1b78b6ebb05a"
    sha256 arm64_sonoma:  "99c5b71336d42f2a34b5d385fd4be25c5843cadf64ddec8b0f6f7a49fac85a8b"
    sha256 arm64_ventura: "d40fcb16a50d7af03d8f8405c7e8358fcc3447d1f5a2ab45caafffd5f86116bd"
    sha256 sonoma:        "5fc73ca3e812c7eca0efd9566d551e6f19ffc5d09bb42ad775063e58c9b45d4b"
    sha256 ventura:       "469e3e39a3cfe526672023f858709ef36a5c2e36e0f331f9edf7ef1af804d9a9"
    sha256 arm64_linux:   "6eee002e41f96cacaaee4e67f504211042a179f247b8145e07d2a6671cae8ca0"
    sha256 x86_64_linux:  "76f12771c7c5d04c33729e069083608825ff10ef5af421837c4d540cc44eacf1"
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
