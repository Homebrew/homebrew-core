class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.45.tar.xz"
  sha256 "3098ada0a24effbde52b0074968a8dc03b7cf1c522e9e1b1186f48bb67a00d31"
  revision 2

  bottle do
    sha256 "a28502ee9c0fd70406782963b395a959d72a1f573aacd63d8d00d88f96440882" => :catalina
    sha256 "014a688cf6672987f9134a65f245fa454a74f4e36a89b9a5d4f7a5a74567b18f" => :mojave
    sha256 "43a7f66a36e3b7e5d5a5b5336241b533eaecfde169511b58feffe9f45d9a99ee" => :high_sierra
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
