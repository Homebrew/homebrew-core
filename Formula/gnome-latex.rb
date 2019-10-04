class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/GNOME-LaTeX"
  url "https://download.gnome.org/sources/gnome-latex/3.32/gnome-latex-3.32.0.tar.xz"
  sha256 "0f069c7b4c6754255a1c7e3e3b050925d8076f55458526a30ab59e0a7d52acc9"
  revision 1

  bottle do
    sha256 "db8d7dc4b428f3fdfe3fb1397856808619c38297ae65306fdaf671bbae40811d" => :mojave
    sha256 "3a0f41f3af768caa2e15633cf1ccce5d3c7119253d914cb4381abe8c0cd3762c" => :high_sierra
    sha256 "908c445ffb71d1907a8a5e0eed94953ba8f61d8ed6222313364a7418c562eab7" => :sierra
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
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
