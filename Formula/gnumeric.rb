class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.31.tar.xz"
  sha256 "c8ace78e75c280dced3f15b27c44c7a98e8d21cd8361c6b2599cce191f6d6ae7"

  bottle do
    sha256 "7f5e66bc40caa0cdaff449c86b0e620c3fb76efb8e1092c2ab15ed316871f66f" => :sierra
    sha256 "f34a50977ece768bc1dc36f1575b1d707144a6f74a1d9309213b3fc2812059d4" => :el_capitan
    sha256 "e6ae60e9466949b26bf195c15d261c4fb0cf99fad028f521b5c1e9c966a365ea" => :yosemite
    sha256 "b0bcddec6232e8ca9c5e24be6e36436b47b8e0a8c6d9c78307464439d09db46e" => :mavericks
  end

  option "with-python-scripting", "Enable Python scripting."

  deprecated_option "python-scripting" => "with-python-scripting"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
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
