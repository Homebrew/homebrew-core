class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://gitlab.gnome.org/swilmet/gnome-latex.git",
      tag:      "3.41.1",
      revision: "4be3578e8fd81ca6593c4927760076ea1acd90f0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "603b189c7d6d338281cf59115a702070dc3ebfbf6b30d6ab243dbb5c5fdaccc7"
    sha256 arm64_big_sur:  "16a97325509f677e4bd1411c7a4fb46d7e5d88b202194a8f1c8dedd30d7ffb56"
    sha256 monterey:       "afd5544db8861e12439e36e3e340446e258c69283d37af14179db69ee6c7b220"
    sha256 big_sur:        "724e5f45e9f393d3a190eee881a444860e4598ee73e2c7657a341b669f903904"
    sha256 catalina:       "16543e61eeee2a269f9cb5b62c7bd5ff9f67f29714ad77e3cef8828883c8de23"
    sha256 x86_64_linux:   "0aa5909fa09856c623a6af0d823185c979627ea19421496690fe6309f0bfc898"
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
