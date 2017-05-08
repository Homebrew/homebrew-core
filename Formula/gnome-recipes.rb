class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/1.0/gnome-recipes-1.0.8.tar.xz"
  sha256 "6affe1f0ab02c35b8e7767039439bd8c9d18dc99336d414684497423a9e091f5"

  bottle do
    sha256 "52eadb3c7c53eac0b2400561e42cbd394a9ad1c4c835319b9a5fdd5d8e66adf4" => :sierra
    sha256 "2190b83cc8fb87b09cbec5733d0a5c24030247be427d1a33548bc52618a0d9c9" => :el_capitan
    sha256 "f41f08d49438c62e0744a0e8cdff12d2f7608c46f8b94968dcd06cf39d42f17a" => :yosemite
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
