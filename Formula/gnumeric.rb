class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.34.tar.xz"
  sha256 "0b4920812d82ec4c25204543dff9dd3bdbac17bfaaabd1aa02d47fbe2981c725"

  bottle do
    sha256 "928a5374903cb03433f98d7c94dbbbf10f38fbaa8aaf963d67be98f64b122103" => :sierra
    sha256 "7742e84a1d57cd6f7965e34d99b84ffbad27e17e563119231e8f339cb4e8123b" => :el_capitan
    sha256 "9c73013f58f6c088b26347d5b9d14a89b733986814c12796d601be81bb7eb11c" => :yosemite
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
