class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.46.tar.xz"
  sha256 "9fdc67377af52dfe69a7db4f533938024a75f454fc5d25ab43b8e6739be0b5e1"

  bottle do
    sha256 "0f2c5361ccf199dca09ec37db79df9c9b9bd4b703afd9d5f947d6f70676c7325" => :catalina
    sha256 "d8dcf90b5c5c8b53b9d9ef0c043e755baf102da1b7b0a5a4f72161ebb7e4a91c" => :mojave
    sha256 "ac070ba1756593dc9781a771d674a866e7d03ba71987cc62d88de8e6dc0a0e2e" => :high_sierra
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
