class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/gnome-latex/3.30/gnome-latex-3.30.2.tar.xz"
  sha256 "558bbd574d3d5a71b9ecde47d7cb5e9ddf7cdbfd21f8f117f09c84c38ddfc33a"
  revision 1

  bottle do
    sha256 "4f7bb1153bdce4fde041b5812e39edd311ef1a20b6cff3237a2449fbf22ea2f6" => :mojave
    sha256 "0c7975449bccf13c0d66ae0cbdc401bb47f3bd710712b80507efaaeb441a34b1" => :high_sierra
    sha256 "df7ecee4622868ff7caeceb1f59730d3932030b9b34390f2cd303485925e8eb1" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gspell"
  depends_on "libgee"
  depends_on "tepl"
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
