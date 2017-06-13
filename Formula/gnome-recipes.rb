class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/1.4/gnome-recipes-1.4.2.tar.xz"
  sha256 "960a705eb15c22ef0ffb7c2cb59fc153a25c2d0624c16a00dda544e5526fe5a5"

  bottle do
    sha256 "45766a8b5d9a6530ee239cbb6251a051a549aa36423c78c39efa812194ce999c" => :sierra
    sha256 "8227a301510b949ae6c4d3331b0d55878acf64b43b7c9b7d38d950e33b4f8023" => :el_capitan
    sha256 "8f6b65add35efca6c964cb963993db06912cb677c1cd067e4977319dc466e93c" => :yosemite
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
  depends_on :python3 => :build
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "libcanberra"
  depends_on "gnome-autoar"
  depends_on "gspell"
  depends_on "libsoup"
  depends_on "gnu-tar"

  def install
    # BSD tar does not support the required options
    inreplace "src/gr-recipe-store.c", "argv[0] = \"tar\";", "argv[0] = \"gtar\";"
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    ENV.delete "PYTHONPATH"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "test"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gnome-recipes", "--help"
  end
end
