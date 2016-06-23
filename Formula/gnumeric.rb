class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.30.tar.xz"
  sha256 "b7c2484694fc7f53ff238fd9d8de9c724dc3c8550e77cf98d5db47351e9d868f"
  revision 1

  bottle do
    sha256 "d81d1a61958af1ecb53780402f7119dbafcb79e55971f37e2b11face6596029f" => :el_capitan
    sha256 "9d2af6b8ab785aec809eae2c3840e8e8fd1f65c27875da5d3d8825a1c1c9b171" => :yosemite
    sha256 "740c6d87205c8b81268668a8eda2996d46d9586637241208808cd624fd57ebee" => :mavericks
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
