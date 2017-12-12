class Latexila < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/latexila/3.26/latexila-3.26.1.tar.xz"
  sha256 "658eba0db71864eb6d4873516d97e05be3e63085ff55513c8f10145ffb657151"
  revision 1

  bottle do
    sha256 "ef78d52b1cd8b25d3a279d340550ac8fde6275d8c760e57b2aa868c9ffbf25fb" => :high_sierra
    sha256 "3d6261fc00154a60e487b58b945a5be211d5863b06bb3794f3231f0983842aa6" => :sierra
    sha256 "0eda343ce69b8769cb2ec2906b5b6fd08de65a0fab6c9ba4728dc46322d72c95" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "vala" => :build
  depends_on "gtksourceview3"
  depends_on "gspell"
  depends_on "tepl"
  depends_on "libgee"
  depends_on "gobject-introspection"
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard" => :optional
  depends_on "libxml2"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-schemas-compile",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{HOMEBREW_PREFIX}/share/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
    end
  end

  test do
    system "#{bin}/latexila", "--version"
  end
end
