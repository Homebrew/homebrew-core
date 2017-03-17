class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/1.0/gnome-recipes-1.0.0.tar.xz"
  sha256 "d291a597c9d5882b03ba21297d6b4b04cd1748cabebe8f4c97b97f9ece3df5c8"

  bottle do
    sha256 "424dff1e1c41b075d33b30a5f35413b074ea586df5d4e41a335fed0b59b7888b" => :sierra
    sha256 "ec1e29ce942aa9505709d2542fa576dc00b2cb10c32116c559fd72d1612b7f65" => :el_capitan
    sha256 "bde7bc64a6026153990d9bfa775d7fbc311585c959ffbb002b28f966c8b46ebc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "libcanberra"
  depends_on "gnome-autoar"
  depends_on "gspell"

  def install
    # orces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-autoar",
                          "--enable-gspell",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gnome-recipes", "--help"
  end
end
