class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/44/evince-44.3.tar.xz"
  sha256 "3b8ba1581a47a6e9f57f6b6aa08f0fb67549c60121aa24e31140e93947b83622"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "cb68c8619b8323f14ad2cd89e00b102b256ce65160dfecd55aeded779d811361"
    sha256 arm64_monterey: "caa718b176db6600e52f3cb7bf0d8d078eda4438bc97e73abc8fbcdc5cf59d90"
    sha256 arm64_big_sur:  "abe4943c44b340681b4abead4d14991f621a68bf97445bcf6dd78b4c55f9a339"
    sha256 ventura:        "5de54c5c34df8dccefe4d769843fcb118fd90a5a19aba83c7436d83f94bd085e"
    sha256 monterey:       "961d87125143cc370e44e4b9e39bfe0a346271ce8a95c2391a8a56f08c707185"
    sha256 big_sur:        "177f9b78c0f0fec883dca0598288e266b23597041456efe20006272ed51150a4"
    sha256 x86_64_linux:   "91937f8b3c625180e593e8fb92cf05b9a8fd34b0134dde09590c7c96d66a93c0"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Dnautilus=false",
                                      "-Dcomics=enabled",
                                      "-Ddjvu=enabled",
                                      "-Dpdf=enabled",
                                      "-Dps=enabled",
                                      "-Dtiff=enabled",
                                      "-Dxps=enabled",
                                      "-Dgtk_doc=false",
                                      "-Dintrospection=true",
                                      "-Ddbus=false",
                                      "-Dgspell=enabled",
                                      *std_meson_args
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
