class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://download.gnome.org/sources/gnome-latex/3.46/gnome-latex-3.46.0.tar.xz"
  sha256 "d67555639b2a15a8aebd54f335354e44fe3433143ae3cb3cca7a8e26f8112ada"
  license "GPL-3.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "d1b02ad59cd60ee54deeaf695c4f8595a0768dc9d54591a57c82f59e75e9be36"
    sha256                               arm64_ventura:  "babf74829df2d757f7b03485c681fbc4c76a43078c247f637ae227e29cfeb822"
    sha256                               arm64_monterey: "d25c28a03cd594f3d65980d1b89820579e0a6be6d3f43d6e2990f3df67f26a84"
    sha256                               arm64_big_sur:  "22644d43bcc27e2429e46fb12e4983d356e0c0ce0f0efe4add127a357f90786c"
    sha256                               sonoma:         "ac843e6ee66c60e7669bc12a36533eecb520d38be5c6071ed83bc1586371223a"
    sha256                               ventura:        "df375601b9b20cb8a3e6fb0621d87f3c57654ba29d44faa669b9947295f5cd89"
    sha256                               monterey:       "6921484d22aeb89bf8d6c8932020a42f704a3a7df8bf4287610ad0b192b1ed3a"
    sha256                               big_sur:        "09c10576ad649d1c3b5d1d72f149618078011264751dd428545deb7abf39ecc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0ea3bae578a8706802e0cad61c2f5ab0bbe1402be092d186ef5de5bdc9b8196"
  end

  head do
    url "https://gitlab.gnome.org/swilmet/gnome-latex.git", branch: "main"

    depends_on "appstream-glib" => :build
    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
    depends_on "vala" => :build
    depends_on "yelp-tools" => :build
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gtksourceview"
  depends_on "libgee"
  depends_on "tepl"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args,
                      "--disable-schemas-compile",
                      "--disable-silent-rules",
                      "--disable-code-coverage",
                      "--disable-dconf-migration"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas",
           "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end
