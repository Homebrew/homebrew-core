class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://gitlab.gnome.org/swilmet/gnome-latex.git",
      tag:      "3.42.0",
      revision: "5041d5c3dcef3116a05bca58239503664ffbcdf2"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "930d96638fdfa8fdc15e50f452a9fd33f819878e6194ae5468d979386b7ca3eb"
    sha256 arm64_monterey: "f0a1374d67f3e5a3416ec7c49b2dd0becda188aea4774876d4ec21787fc59b26"
    sha256 arm64_big_sur:  "84603140dcceb7e96df5c429e1c6ccc5e740f23bb545a2e74e25f2481a9efd07"
    sha256 monterey:       "00bf13cfa1e9fec224bb7c99dddccc330719eb625e6cd6a6573652dea939a017"
    sha256 big_sur:        "cc75843ff9481af928248ffe5f9d695461a09e462664345392a7afbe06f59955"
    sha256 catalina:       "22ca62489c8861fcf136700d956ebfb7469a40a5affd28ec06525dda0dca2563"
    sha256 x86_64_linux:   "7b9f185a80a446e0ee83eeb36e0ced778476e7cff18732a530a0f556d731f89b"
  end

  depends_on "appstream-glib" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "yelp-tools" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard"
  depends_on "gspell"
  depends_on "libgee"
  depends_on "tepl"

  uses_from_macos "perl" => :build

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" unless OS.mac?

    system "./autogen.sh", "--disable-schemas-compile",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--disable-code-coverage",
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
