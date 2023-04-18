class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/44/evince-44.1.tar.xz"
  sha256 "15afd3bb15ffb38fecab34c23350950ad270ab03a85b94e333d9dd7ee6a74314"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "3b40a2075b5464aa3d80713c710febd13f54de4b6cd3f00281b7d12079798c22"
    sha256 arm64_monterey: "287cbec787ea923e100d5f4494e119414a3e8cfbb5b5d6a899083948665d726f"
    sha256 arm64_big_sur:  "b7a1f682f691bd39b2329589261bb4cba0b03f5b848addd2075e7d4045f02f6e"
    sha256 ventura:        "68aa40e7332c4c25f95d821ef840d387cb75d744213fd1933a43611a747c859e"
    sha256 monterey:       "f2e38569fefce2c2c470336d7cce6f61c24f75408fd03401b3fe7b2267d4ffb5"
    sha256 big_sur:        "37e4a33300fd3089433ab5daed5659fd5b4da958b908cc09aa36eb61268b3e01"
    sha256 x86_64_linux:   "4800ea5180ab01fe6a427d171e69471367ccd8c51cb2e9286b198d4d455afe61"
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
