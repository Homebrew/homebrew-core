class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.35.tar.xz"
  sha256 "77b1e3ce523578a807767ad71680fb865ac021d7bfadf93eada99ae094c06c0a"

  bottle do
    sha256 "1448fa9e69c8d238a2b59638558f019e399bf0077d21e0ffaa69bcf115dba667" => :sierra
    sha256 "6a855cf912aad4b5dc66dba9e6f581959a5a37a5f4220763bf50a0adfabe19b4" => :el_capitan
    sha256 "230654df946592633208077ef2e515762920d6c9e4b31b097d389626a1e6e0d9" => :yosemite
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
