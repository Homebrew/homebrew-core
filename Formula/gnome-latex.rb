class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/gnome-latex/3.28/gnome-latex-3.28.1.tar.xz"
  sha256 "02105e81765388faa9f75ccb43b745b1d66bfb14285b7855e6a7809e7f0c88fc"

  bottle do
    sha256 "59d72c577c10d9e032a9e53dae59a0ba2112cf1d57dcde7f6aa51f5dee77b2a5" => :high_sierra
    sha256 "b72bfdac7b8a17287eff0d161ba5256cbea178200390861f99a3ff00c0488879" => :sierra
    sha256 "992c16edceb9836d19046f2f3df72ca1ba44ce111ccd3c1a4a830e7c820bb0b8" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gspell"
  depends_on "tepl"
  depends_on "libgee"
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard" => :optional

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
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{HOMEBREW_PREFIX}/share/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
    end
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
