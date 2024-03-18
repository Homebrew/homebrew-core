class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/46/evince-46.0.tar.xz"
  sha256 "aff6af69392c04956bfad976dec5d1583b41d5a334e937995f7c3ca0740de221"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "2d7de07f0e32e455ab53524d8ebb23e70a969e31278a9bcb93fe9fce00a9e0ce"
    sha256 arm64_ventura:  "53d2cbd7a0130b501c6bf0083a450496975579e1ffcc19aa121e2d4da131e12b"
    sha256 arm64_monterey: "00c0e6884132528f2e3c76c07889ec368f835f8390a785ed8a6fb71e4b8c39d2"
    sha256 sonoma:         "c33a2d0f2a933d21635ee0237e7a628ab29b566f4ecedb60ea8a354dca140036"
    sha256 ventura:        "41f6401df7d5195a56b7104142bc52bb574f0b0881c213c3714ec39f7183049a"
    sha256 monterey:       "de4b8aaa5eab3c811d642f49be3ceeec9729f8bcc632b2b50d4a138f15c11bcc"
    sha256 x86_64_linux:   "d759f48a208296c412b9cd0fba7b3b13ddd46c5954adc25e8a78d3f5ea5652ed"
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
