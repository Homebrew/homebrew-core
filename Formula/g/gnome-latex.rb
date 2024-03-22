class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gnome-latex"
  url "https://download.gnome.org/sources/gnome-latex/3.46/gnome-latex-3.46.0.tar.xz"
  sha256 "d67555639b2a15a8aebd54f335354e44fe3433143ae3cb3cca7a8e26f8112ada"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "1c13cd8534607f8800921e54380c5c8de54a65bf6dc86343bcb9eeae270d0c6e"
    sha256                               arm64_ventura:  "6eed165be159ebbb4a115b25fc89f0c6eb1894633795cc14866c81eebaab7f6d"
    sha256                               arm64_monterey: "953fb8dfebd9d4c447c31059e06a744ec67481cfa32bc7a4716a1ef0f13a7def"
    sha256                               sonoma:         "3afd744e2662cca98f1bd308081c70b9c4238dd81814529c496ff781cc522927"
    sha256                               ventura:        "b0f7cd7369ff7cab0e673666e665a816025252ddaed489a643b4093224b1c838"
    sha256                               monterey:       "a4d75e7e66c5caddefbe794455fa06450caf59f942060e0e170225aa9b2fe853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d816325f5767669b7d709f3c9d5976b021345d124a2728984348c66d43fea6e6"
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
