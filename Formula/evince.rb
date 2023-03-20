class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/44/evince-44.0.tar.xz"
  sha256 "339ee9e005dd7823a13fe21c71c2ec6d2c4cb74548026e4741eee7b2703e09da"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "44e33b37807ca76fa403ddef62ab07e03fb444fe5af0747cb92bcf93e8896e82"
    sha256 arm64_monterey: "510540073c430950644b2b0e9c9c7597b6f8d1e765037b2d88afa0869f9da33a"
    sha256 arm64_big_sur:  "c3ddd6e267c69ab55b65aad1486ee2c440f6d1902c553b218ffb45d40fc49467"
    sha256 ventura:        "94adc769189a7bdb58d0c69fb68dcdb2bf16221e6ec5759fd29c3ffad82e5613"
    sha256 monterey:       "8c5b209413edcf25351a6bb00e9e4259a06de62f2e67eb1f27cd24bcf39265d9"
    sha256 big_sur:        "5f22075a1a94e3d9ec242afd75ff31cd54a4e789cd4314143da2653fc7da853a"
    sha256 x86_64_linux:   "d2bb1e345441d60bb1333099732629aabfe29f92415923b8a70844c1524a66da"
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
