class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.45.tar.xz"
  sha256 "3098ada0a24effbde52b0074968a8dc03b7cf1c522e9e1b1186f48bb67a00d31"

  bottle do
    sha256 "169b85af294458a8cacfef4d805db710254ad11839fd234c6191d8cc4b0b7a63" => :mojave
    sha256 "f3d1b3055bb396161b36d488dd968b92cb2c221a689ce6e9afec9b46cd069ede" => :high_sierra
    sha256 "57d163989a10c0f70aeaae9005ebf3c9dd784e1035d5b6769f8e63182514c9a8" => :sierra
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
