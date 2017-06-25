class Latexila < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/latexila/3.24/latexila-3.24.2.tar.xz"
  sha256 "89042a9253b3e150d56bada649d47a9879fd702fc46f73be5649b0edad3f1183"

  bottle do
    sha256 "1f7325b4e75c112185cf49b86f5e05ea013f40c4db3cddd8fefaa05fc965bff6" => :sierra
    sha256 "74b9e1021f438624aa47e96c01b1cd2a59cd0184e4075542c59aa17bf7e6fb41" => :el_capitan
    sha256 "441ecb13f217b9a689a6107a9418e758bdae973eadd28f40c988db37c826838d" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "vala" => :build
  depends_on "gtksourceview3"
  depends_on "gspell"
  depends_on "gtef"
  depends_on "libgee"
  depends_on "gobject-introspection"
  depends_on "gnome-icon-theme"
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
