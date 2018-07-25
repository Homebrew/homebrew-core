class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/gnome-latex/3.30/gnome-latex-3.30.1.tar.xz"
  sha256 "881bd3c135b31a8c07f590537471ec2fd6c2fdbede6021fff5b1ce18c2b8737b"

  bottle do
    sha256 "566e234489614ad03204a26608a4b27e18ba17ff6d516b19886c634da7820b32" => :high_sierra
    sha256 "8138aadd3e89ddd9475e30ce23b57edf1e411efabb69f4717a05d4cbb7d20156" => :sierra
    sha256 "4a82495e48ba9ee75d1ac2416132bd0e5d9559f1c949e105f63d51c59d5f631c" => :el_capitan
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
