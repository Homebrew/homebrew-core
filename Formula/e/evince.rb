class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/48/evince-48.4.tar.xz"
  sha256 "f296c5c662886635d4cd597e8ac0afcde7982be4486533c2b7f095b268be8668"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "50fd46e30a5ad1bd12b39a183b2dfa2b1a7a33720caeb507582277a42b088a30"
    sha256 arm64_sequoia: "744afff8b2653517ecbd8d92ce03ed8da0723dd6bb3b5d72f9f697f09e4b68fc"
    sha256 arm64_sonoma:  "e2ac1a99c1a4a34a2e35567608a23c18389b803d8fe6ba316cc0144b459b1091"
    sha256 sonoma:        "6acf1c1c2f9f8ba50197ec410154c7e2f5e65cbbe30f4d822d3f2c4f86500f6d"
    sha256 arm64_linux:   "c653ea149c80a57e11499d1d71906d38d22f4dc77eab85c70f71eeb2f781aee2"
    sha256 x86_64_linux:  "25c5975817e4c02e346b2f75c3eaeb27bbba00216d0f77c9d2ebeeeb91272906"
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

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
