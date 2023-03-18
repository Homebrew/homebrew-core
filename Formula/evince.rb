class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/44/evince-44.0.tar.xz"
  sha256 "339ee9e005dd7823a13fe21c71c2ec6d2c4cb74548026e4741eee7b2703e09da"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "4663c8637d9de02308b1e65a0f71570cf95883ae5c560374e44859e18a5a0f99"
    sha256 arm64_monterey: "7675f40d279cf544e0df36155184b54d244f0c9cb8970a7a9f9e767d46f94f44"
    sha256 arm64_big_sur:  "ca3a9d32aaf0765e6e941d336b602123c464086fd308f2fad8a5f53b094f8564"
    sha256 ventura:        "f3c27dacdab6783fc06fad4cdbc548ffe8774e5671d2b557483574854f053f65"
    sha256 monterey:       "ac1e5a9f93686eee264c0567fb477271b40f1b9d0043ac629b7b2407b92ba264"
    sha256 big_sur:        "2d70f1a55d9d65e7309aea7986cb2ef66df699421461a254e650e000889a5684"
    sha256 x86_64_linux:   "7424c6e6d75d8eeb2c9bf302d360bc35c3fea37aa0a535e5099fbb899309b91a"
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
