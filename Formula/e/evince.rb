class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/46/evince-46.0.tar.xz"
  sha256 "aff6af69392c04956bfad976dec5d1583b41d5a334e937995f7c3ca0740de221"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "e2c83dbdc98781f2e491ebc1f2c6543df0906eaf1e99a116ddb137f88329b234"
    sha256 arm64_ventura:  "3bdd7a7eaa9ad4917f93aed0d4d1322535db46f240fcf9c0182a1fcd7828b6e2"
    sha256 arm64_monterey: "bdd9235a03c460ea1b9512c82f8d452aa807e7b49bfc181504aaedb8e0cf04fd"
    sha256 sonoma:         "c6122d80c78bdfaa2e781971fde4f1f7c25688af84d7a11a3333d92ad23d6e52"
    sha256 ventura:        "ae39150e842006506abdeb002e60fdf96ecba6f1d9cd669ceb876c35f394fcc0"
    sha256 monterey:       "fea31c0ebac386ab0b11b7205c8e9c792786bbea1271cf4d77010633c589e1b5"
    sha256 x86_64_linux:   "25b2e8dd8ec2435599de6e8925bb58ab007c554f0b0a4096e57b53d939ae73ba"
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
