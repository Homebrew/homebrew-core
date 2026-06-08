class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://apps.gnome.org/Evince/"
  url "https://download.gnome.org/sources/evince/48/evince-48.4.tar.xz"
  sha256 "f296c5c662886635d4cd597e8ac0afcde7982be4486533c2b7f095b268be8668"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "923f1a8b070907f738b721c5679808fd8edc7e4ce5e71b87513316efcadaf370"
    sha256 arm64_sequoia: "bcfecd2f93943eebb8aea3ad8b52898c6d3be91d0df4183dd808ec7c4f17944e"
    sha256 arm64_sonoma:  "4ce89c822d5ad2b119ea61540206ed09891eae79b5fb938d185c35454af86798"
    sha256 sonoma:        "3d9445cdd69197e11e053425b47b8ab08d98e3e1fed4f54082e2e9c044a5ff88"
    sha256 arm64_linux:   "455027196a3f4544a628861d242bd21ffed47e77f4915d1972f51883a40340cd"
    sha256 x86_64_linux:  "e0d069b917e21e53124fc26c1fd4ad4fa7848f2c9ba44a24a9a47422b41e48a2"
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
