class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://gitlab.gnome.org/swilmet/gnome-latex.git",
      tag:      "3.41.1",
      revision: "4be3578e8fd81ca6593c4927760076ea1acd90f0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "2512bc0320e672d89d5e8453b3bfc4ccdae8c8da53789e87c1e4f9d71b96132a"
    sha256 arm64_big_sur:  "29cda278f13333a36822f226ab004ca6c0631f05c422ff82f24719051eae5476"
    sha256 monterey:       "6846a21dcfca6c5c7ab2c664174e19e777a7e1fd340f3d8d7a3be3a187533dd2"
    sha256 big_sur:        "7ceff4652331ae25ca2de90ed4e57840a11e5e78e59cbcadcb4dd546b603e312"
    sha256 catalina:       "fb219b67458501d6d4d9ed2e72da6996e91f86095ebefdf008892f257ac2c8d5"
    sha256 x86_64_linux:   "4d4578faf140e4ac55a7e267a9bc130a3cb7d2a1ce8482ac83280707740fcf81"
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
