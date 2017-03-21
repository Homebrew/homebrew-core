class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.34.tar.xz"
  sha256 "0b4920812d82ec4c25204543dff9dd3bdbac17bfaaabd1aa02d47fbe2981c725"

  bottle do
    sha256 "86643beecac3bca21414b58da0d78f6e9ecc690b3a29945327fa4fa2e3795396" => :sierra
    sha256 "4d51ad3c8b9a9f3fa3426ab86b4d3ce9e39d7a40d733dcd48e57aca263696670" => :el_capitan
    sha256 "f7a0dea619c437ae5a4e4990eb4f65fdfc734172df7d74cc862b80de48a66a1c" => :yosemite
  end

  option "with-python-scripting", "Enable Python scripting."

  deprecated_option "python-scripting" => "with-python-scripting"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "goffice"
  depends_on "rarian"
  depends_on "gnome-icon-theme"
  depends_on "pygobject" if build.with? "python-scripting"

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
