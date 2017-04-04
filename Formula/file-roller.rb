class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.24/file-roller-3.24.0.tar.xz"
  sha256 "f4b72dba69b1984d96a1a9a6c544a9f94e54a531612b299251ef2702e0b0ad21"

  bottle do
    sha256 "98d8ba1358f1f1e90246bf582b87469fd6db750c46f825d84fb26bbbfd3a7ad5" => :sierra
    sha256 "918cc1c20707d77d9965f3398d2914f898476726266dce77133dd5b93ffe0b00" => :el_capitan
    sha256 "adc16f9b3220644965dbbc88af9d1b8bc08837ae1c484e5e5654d9187df5fa52" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2" => ["with-python", :build]
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"

  # Add linked-library dependencies
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "pango"

  def install
    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--disable-packagekit",
                          "--enable-magic"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end
