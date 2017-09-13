class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/1.6/gnome-recipes-1.6.2.tar.xz"
  sha256 "8a11ed483b422dbbedb10237dac8b47fe94d76d40cac87ae6d19292942c94f9c"

  bottle do
    sha256 "7c728c1576db3adfbf2e1f4e3055cbc3e21b6f692cf6a8c575ebac09abc0c4c9" => :sierra
    sha256 "aefaf33fcd61848e9520bc82f6bcb34123688e114781c7ffcad4a009123535cc" => :el_capitan
    sha256 "437277c49b5dd39e73611fdf4843e1dad08641c5dc91b3756a94a34dc05a38cc" => :yosemite
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
