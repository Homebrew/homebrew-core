class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.20/gnome-builder-3.20.4.tar.xz"
  sha256 "b3e69495cd0fcfd3e3a7590f52aadaae7f45393eefd47ab5581a851cdd489041"
  revision 1

  bottle do
    sha256 "721c67af0e9bd89b0afdd1fcd61aa7039b63707655243c09b8ff67cd175dc3ad" => :sierra
    sha256 "f998975b2542a7b8a28a0c3c59a5a01efc025f6452bafa742021be3ad07115d6" => :el_capitan
    sha256 "485b20e976415463b143b67c4f778e7da373a68d6053d1c1b1f4807fb8c8115e" => :yosemite
    sha256 "bbcab43c4a10dd4bca406eae433cdbd6c459c97decdd67fa8fa8870aa5da5bd0" => :mavericks
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
