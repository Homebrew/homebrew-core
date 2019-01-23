class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.43.tar.xz"
  sha256 "87c9abd6260cf29401fa1e0fcce374e8c7bcd1986608e4049f6037c9d32b5fd5"

  bottle do
    sha256 "1317c0b0a36c781ea587b3411a2b7c7ccff9206fed085e002e4bbef339130e99" => :mojave
    sha256 "f4a007bcb9422d69d6217c08f9af877ed61cdf51d919fc88eb6d905c1aedaf3f" => :high_sierra
    sha256 "d7db9d5d98fb58473c411d22683e8de5e73fe6e965dae5bdbd8d3fd243a59826" => :sierra
    sha256 "c987c86ec64c80322d7f602234ca1e3e144889bf72d6144f9d1b5ffa76879ec8" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "goffice"
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "rarian"

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end
