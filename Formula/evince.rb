class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/44/evince-44.2.tar.xz"
  sha256 "9a75c7ff8f599218d070e09fb4082cb26f9b86370a9bfae98e1aacb564d675dd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "917f5a6cbde47ed3716d05303e45c12ef77ad30cc8bbc00e032748a263695f95"
    sha256 arm64_monterey: "d09df03822ba71758f04e103b1727234f1bff66d4ef264812cec6573cd8d1e81"
    sha256 arm64_big_sur:  "2c119d07d3806f0f58cfdfa95bbc41b216b10a4dd53293742bdd791711f02477"
    sha256 ventura:        "634fcc103631cee1eba0384addff67dba919a2be0ab52824daabab7cc2ae7ae5"
    sha256 monterey:       "8bc747ea4720b25aff9ad4a0d285bb9bd1ce80537bc63b311c724749e25ec108"
    sha256 big_sur:        "89cd713e6a3dfe911a68b043438f92a141a3b9be926dd3ae969e8b187961e4d5"
    sha256 x86_64_linux:   "480a9976d48e0c3c6a761a6fbd79ba86bf7ed195e45dd79c6fbe36190fece141"
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
