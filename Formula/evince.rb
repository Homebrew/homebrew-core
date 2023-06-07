class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/44/evince-44.1.tar.xz"
  sha256 "15afd3bb15ffb38fecab34c23350950ad270ab03a85b94e333d9dd7ee6a74314"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "8193e53fad0d662f805424ef2bfb4f7c57a189a104e0e288e8d2c92f970e6fa0"
    sha256 arm64_monterey: "c15c434b824f495abef7be408c6c651aa68c031021c7c902e33c04f362db7a5c"
    sha256 arm64_big_sur:  "e5b31ce5d617985ab0b009c4f0acb3e273683af4ae31e5347ae16260f86e3212"
    sha256 ventura:        "ec9a88fc211c89eaa64d0e2cfd4b9a58e82e3d509d00ce934eab630559386c53"
    sha256 monterey:       "147b610eeca29f147504fea46348600a6b3f6e4b47c4093a33271fb21d2483b5"
    sha256 big_sur:        "d7521039359daaac103a4da9433927c431b918d1c9bcee1d367436904b9bdd14"
    sha256 x86_64_linux:   "1b8553667efc9587fc98b8f646ee6dd98f493138b75eee475778c9ba26b5bc96"
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
