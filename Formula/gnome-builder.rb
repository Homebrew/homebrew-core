class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.22/gnome-builder-3.22.4.tar.xz"
  sha256 "d569446a83ab88872c265f238f8f42b5928a6b3eebb22fd1db3dbc0dd9128795"
  revision 2

  bottle do
    sha256 "9696ce453f8388bf34a2bfb0259634accc017a505a46354829a6de1c651eaafa" => :sierra
    sha256 "780097cac9ca5f467816c33bd1cec41d805bcb01633e15c0d0fb6a9d927e309d" => :el_capitan
    sha256 "c16df3dd5f759fae32ed0e28c3f10ec5775bf0668f25e472f917d6dc0010dfc1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "mm-common" => :build
  depends_on "libgit2-glib"
  depends_on "gtk+3"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "pcre"
  depends_on "json-glib"
  depends_on "libsoup"
  depends_on "gjs" => :recommended
  # restore vala support in gnome-builder 3.24.0
  # depends_on "vala" => :recommended
  depends_on "ctags" => :recommended
  depends_on "meson" => :recommended
  depends_on :python3 => :optional
  depends_on "pygobject3" if build.with? "python3"

  needs :cxx11

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libgit2-glib"].opt_libexec/"libgit2/lib/pkgconfig"
    ENV.delete("SDKROOT")

    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-vala-pack-plugin=no",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnome-builder --version")
  end
end
