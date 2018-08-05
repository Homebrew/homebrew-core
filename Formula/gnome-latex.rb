class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/gnome-latex/3.30/gnome-latex-3.30.2.tar.xz"
  sha256 "558bbd574d3d5a71b9ecde47d7cb5e9ddf7cdbfd21f8f117f09c84c38ddfc33a"

  bottle do
    sha256 "63c1df21e678e106a4d3e80ee7a58960721bb948c1746ab28dfc08aaea6bd18c" => :high_sierra
    sha256 "62400be4daea03006548bc18aa82f7900ef8cb9462f7f9d5c0af7eb39745ebce" => :sierra
    sha256 "8a1a0eb8af6ebcb43d4ea2e5f654d9124e7fb7ba923f9592ad6fbc40c8c47416" => :el_capitan
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
