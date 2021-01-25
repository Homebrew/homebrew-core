class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/GNOME-LaTeX"
  url "https://download.gnome.org/sources/gnome-latex/3.38/gnome-latex-3.38.0.tar.xz"
  sha256 "a82a9fc6f056929ea18d6dffd121e71b2c21768808c86ef1f34da0f86e220d77"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "dc38c7827663f49f553996a757415dfe20d92c8c0dea83c462c887c8daf69f5f" => :big_sur
    sha256 "8ea1216cd53e87eb4c9667c90e29cfc007f115129070ef1dd205f2a2480900f9" => :arm64_big_sur
    sha256 "f1dbea254436194246d1ea3fcd47a5b08b394efb3a08f48a9a3decd85120ce90" => :catalina
    sha256 "c8f5a18378b6a759f3f4614baedf693814b61da0dfecd2f0d8d6ad93bef3fa25" => :mojave
    sha256 "7a9d3285f2457fecacc4e0840e32ac940b0e77041dd30839e6a7af7ad55453dd" => :high_sierra
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
