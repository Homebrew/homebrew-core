class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/46/evince-46.3.tar.xz"
  sha256 "bc0d1d41b9d7ffc762e99d2abfafacbf745182f0b31d86db5eec8c67f5f3006b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "fd325d001f0a26ede51f1169cd1d69f62189e22ca772ccf5949bf742702ee5eb"
    sha256 arm64_ventura:  "4d2cf11142d80118155c6316be3d58a992a4d73c0345209e82a049a17fe5634d"
    sha256 arm64_monterey: "8d230caaaa8ac63110bbdb04ea34656a1296cc3bb6d4873f7ef460e7dcaeec98"
    sha256 sonoma:         "ba35131ca8404a18efb242555db8937e2c6e6ad6bdc6990717e2c174b177e8d2"
    sha256 ventura:        "37dd9fab3bcc8986dc1e65b65a458197ff2d1d0f27e6a19a5c3f2271bf87ac72"
    sha256 monterey:       "ebf12efd418ada6fd8f791e706dc3d8501cf91cca5e621ac54ec59ecc75066ce"
    sha256 x86_64_linux:   "0fd0af71e2fe9b040ac804c68b6f1129b34d68803fb114a2d272dab2b34842d0"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
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
