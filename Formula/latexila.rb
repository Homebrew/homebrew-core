class Latexila < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/latexila/3.26/latexila-3.26.0.tar.xz"
  sha256 "192a6759718e2b2122438a397bd37e90cb2f10b9ab30cdebfe2124e37cc3926d"

  bottle do
    sha256 "8bbe8391a2fe71b5b3579d26e6554188e7552d3b33347058f328667c8f755d21" => :sierra
    sha256 "487f47d6785da634cb9031715ed3e325f5cffd4920fab98ef597cf536f948471" => :el_capitan
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
