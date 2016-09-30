class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.20/gnome-builder-3.20.4.tar.xz"
  sha256 "b3e69495cd0fcfd3e3a7590f52aadaae7f45393eefd47ab5581a851cdd489041"
  revision 1

  bottle do
    sha256 "44617ae64945b8da767a54187685fdc5872ad3675283e06c9095250d424a42d7" => :sierra
    sha256 "15a98acdde06b8b37f30af0c09cf5311983f62909944d92f27dcfd0dd56bbc8c" => :el_capitan
    sha256 "9e2072f45d762d7b38c231befbfba2882b812e2ae33da05cfe4bbc0486317f10" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libgit2-glib"
  depends_on "gtk+3"
  depends_on "libpeas"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "pcre"
  depends_on "gjs" => :recommended
  depends_on "vala" => :recommended
  depends_on "devhelp" => :recommended
  depends_on "ctags" => :recommended
  depends_on :python3 => :optional
  depends_on "pygobject3" if build.with? "python3"

  needs :cxx11

  def install
    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
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
