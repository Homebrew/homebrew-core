class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/GNOME-LaTeX"
  url "https://download.gnome.org/sources/gnome-latex/3.32/gnome-latex-3.32.0.tar.xz"
  sha256 "0f069c7b4c6754255a1c7e3e3b050925d8076f55458526a30ab59e0a7d52acc9"
  revision 2

  bottle do
    sha256 "2f4018d35ea99c5c8c6dbaa0cdb92e40d1392739c8c786cd381a2153d4ae7dd0" => :catalina
    sha256 "eb5d1ee1c770b904d7cb2643c34be87a0b8bd55acadf8b1accb7c5c4d04f3c03" => :mojave
    sha256 "0ef723d17e744eeed76eb2653efeb37b3224e2d6f6e7fa8e5c4f3ed9b42c25ef" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard"
  depends_on "gspell"
  depends_on "libgee"
  depends_on "tepl"

  def install
    system "./configure", "--disable-schemas-compile",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-dconf-migration",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas",
           "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
