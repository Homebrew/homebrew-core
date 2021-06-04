class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/GNOME-LaTeX"
  url "https://download.gnome.org/sources/gnome-latex/3.38/gnome-latex-3.38.0.tar.xz"
  sha256 "a82a9fc6f056929ea18d6dffd121e71b2c21768808c86ef1f34da0f86e220d77"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_big_sur: "118ac80bf869460f820e12a63bf8808b7ad9158eeb3ee594e494e344d54cc97c"
    sha256 big_sur:       "91916490eae6b8b5e9c8717ea9a37a2e8e383c6504a3d59c7d4f209d2f2e5db0"
    sha256 catalina:      "34723bd50c23bc34d54750606f99247544a222f8d32ee1017422a618e7d8255c"
    sha256 mojave:        "282a45a8580c354c10f112895d0448cc97e206da12460f75b6dbcc8906401314"
  end

  # See: https://gitlab.gnome.org/Archive/gnome-latex
  deprecate! date: "2021-05-25", because: :repo_archived

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard"
  depends_on "gspell"
  depends_on "libgee"
  depends_on "tepl"

  # Add commit to port to Tepl 6
  patch do
    url "https://gitlab.gnome.org/Archive/gnome-latex/-/commit/e1b01186f8a4e5d3fee4c9ccfbedd6d098517df9.diff"
    sha256 "0d54059732cb3092f52bfb8bca6ebad24a08b86036baafb31e06aca2415517ca"
  end

  def install
    system "autoreconf", "-fvi"
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
