class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://gitlab.gnome.org/swilmet/gnome-latex.git",
      tag:      "3.40.0",
      revision: "d488276c58b0d126d34e1facc431c153664d980b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "6c25d1dc2043da0fd0618c57316b19e59fa7627c61ea01051a38384c1e6683ac"
    sha256 arm64_big_sur:  "118ac80bf869460f820e12a63bf8808b7ad9158eeb3ee594e494e344d54cc97c"
    sha256 monterey:       "ec4d6862103ee03a5198148a0ea22acb97c1da93ef91af2b793bddb339f4e9c5"
    sha256 big_sur:        "91916490eae6b8b5e9c8717ea9a37a2e8e383c6504a3d59c7d4f209d2f2e5db0"
    sha256 catalina:       "34723bd50c23bc34d54750606f99247544a222f8d32ee1017422a618e7d8255c"
    sha256 mojave:         "282a45a8580c354c10f112895d0448cc97e206da12460f75b6dbcc8906401314"
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

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" if OS.linux?

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
