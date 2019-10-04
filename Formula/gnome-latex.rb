class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/GNOME-LaTeX"
  url "https://download.gnome.org/sources/gnome-latex/3.32/gnome-latex-3.32.0.tar.xz"
  sha256 "0f069c7b4c6754255a1c7e3e3b050925d8076f55458526a30ab59e0a7d52acc9"
  revision 1

  bottle do
    rebuild 1
    sha256 "971e6075ecf611cd7fea6fbf4c7b27bc0dbe7ef9bca677e81aab6c03e7f05c80" => :catalina
    sha256 "acfa900c9110809e11e3af98d3f6cfd26af2cd711739a6d67cfb6015671d26b3" => :mojave
    sha256 "9dd75248dcdd5ef49028ed307f2bafb793399024559fd352abb1358e9f0df5db" => :high_sierra
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
