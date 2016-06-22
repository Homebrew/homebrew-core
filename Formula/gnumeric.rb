class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.30.tar.xz"
  sha256 "b7c2484694fc7f53ff238fd9d8de9c724dc3c8550e77cf98d5db47351e9d868f"
  revision 1

  bottle do
    sha256 "e37fdf8a64b330a852b4031a3b259c838870a986bef61aeb4973a9c197ca3adb" => :el_capitan
    sha256 "b45ef55e47fc9091e369ba15c3980ad88a90aa4f6b9205f38c0f840da4e24207" => :yosemite
    sha256 "08754894e2fb8302aa01ce901d63be60e5cb4f0385505f77c3759047acf660ea" => :mavericks
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
