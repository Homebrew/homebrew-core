class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/1.0/gnome-recipes-1.0.8.tar.xz"
  sha256 "6affe1f0ab02c35b8e7767039439bd8c9d18dc99336d414684497423a9e091f5"

  bottle do
    sha256 "f420a5b1fa81429f0f003b8208639d6cdcfd396eabaf523d830771ad066090cc" => :sierra
    sha256 "f35930f39720debca38c40569fcbd5d824d756ae38514701a19e40a64c9c05f3" => :el_capitan
    sha256 "1e743084d94a7387bd3d398c34a7b0a761a60fdbbcdee1efb72a88682d4d5cc5" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
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
