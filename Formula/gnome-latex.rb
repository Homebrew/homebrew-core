class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/GNOME-LaTeX"
  url "https://download.gnome.org/sources/gnome-latex/3.36/gnome-latex-3.36.0.tar.xz"
  sha256 "1657238f4e2b419fe211e4b0b51a20889f44e6e3f498b87e25e032f8439ec9a0"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "df723e3dd919a9d020089e8e19dea1a65c9f621907519fd35e4330cb69d53c28" => :catalina
    sha256 "d82135bcbb899a686ef55bbbfea0eeecc1267da9e5bc075274a01b720ea9441d" => :mojave
    sha256 "f6332db50b6a791c5fb73abe2b26b097b9f60acb78cb7a8b1ce398ec3e04d3fd" => :high_sierra
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
