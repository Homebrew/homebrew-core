class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://gitlab.gnome.org/swilmet/gnome-latex.git",
      tag:      "3.42.0",
      revision: "5041d5c3dcef3116a05bca58239503664ffbcdf2"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "2ce74461c6544307ce6ef78ca8ee4a041955401dadb131f95cf28df1d11a9ac4"
    sha256 arm64_monterey: "ed4db46967ee4e4a49617ccb1bab481aaf8c01c772fe98f4b09cec1374715ea8"
    sha256 arm64_big_sur:  "65daa605789bb193d0fcb02e45207c4ee200c28213dc923b2b0c6c2d3f64884b"
    sha256 monterey:       "e6faaf0aff9d05e3c60261a37f65dba8036903c718cd40f9057825901b513498"
    sha256 big_sur:        "9fc46312b67c240185ef1929a3e3660aaead71cbd0ede56aaaf6422cc3429b8a"
    sha256 catalina:       "224ac8c01214d4b9171a7dd7432b441fe3631ad48b8f7bafa1a306bf894e31c2"
    sha256 x86_64_linux:   "ec254c8a93ae75f3fa3c3af37415c051731090348db585b7e2b99869812aee5f"
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
