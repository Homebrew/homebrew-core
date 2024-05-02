class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/46/evince-46.1.tar.xz"
  sha256 "94bb525365b060a28c2f6017d22cbf2af5115507254aa42e9bfc000bbc18ab62"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "ec95a235caf027b39df607166736e84cadf3eace6e20cb8e9fbf6d3dbb0b4bcc"
    sha256 arm64_ventura:  "c66797edb522fb4c96bbfdb21a41ee8b6c57a9ad47c7216ba8ee997781432466"
    sha256 arm64_monterey: "60a0c9948dc12632a4b42575c2ff76a11dd8c410981b4a246015954c0a7e71ae"
    sha256 sonoma:         "709281ada16cd5535d0a5f5b4fcf52dff1aab9e9407a43f73b69b42a2d1d98c2"
    sha256 ventura:        "c7612bb7d4caec292e23cae3f1582030dec1beb15e2372fecf45a5d5514d5aa1"
    sha256 monterey:       "f616f09080b5cdf6927c48c772f783b94d3bfd42cdd6a569e9d3326ab73ebce8"
    sha256 x86_64_linux:   "6f118a4bead166de35558897b55f8ee46fe8596813882bd199e2e1b47eca6956"
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
