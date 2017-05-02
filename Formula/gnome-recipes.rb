class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/1.0/gnome-recipes-1.0.0.tar.xz"
  sha256 "d291a597c9d5882b03ba21297d6b4b04cd1748cabebe8f4c97b97f9ece3df5c8"

  bottle do
    sha256 "6f783969775cd0ebbfee608bf170fc1252749e476d5c5da9e5359f963945b15f" => :sierra
    sha256 "9b18aa73043e900777cc2104d2c9dfc3078a9756be7464c1c38396438d4841b5" => :el_capitan
    sha256 "dec400d3b3e7decc6830504daf67d785b4cebd5b8feceb1e2b2dcadae0ddd033" => :yosemite
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
