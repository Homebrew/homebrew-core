class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/2.0/gnome-recipes-2.0.4.tar.xz"
  sha256 "b30e96985f66fe138a17189c77af44d34d0b4c859b304ebdb52033bc2cd3ffed"
  license "GPL-3.0-or-later"
  revision 3

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "aa4f377580d2f261bf6997d22203eab2ab4a41dd25ac493c31c156712ffeebb8"
    sha256 arm64_sequoia: "3bdeeed9601b21231a0681c228ad2c69aeec741c8a03e254927a6563691b8ec3"
    sha256 arm64_sonoma:  "6747e4b6466b029d7752f666b49efd402420d1f849ba297d1826ead4c3afd357"
    sha256 arm64_ventura: "f6034dd729fdcb7445b1e41d873d4bf19fad4e8ecd756bef137981ae3337e15c"
    sha256 sonoma:        "2adb5d5d5318f31ec63b8b76e3d220a2762dcb7ee47e66e64f97099ec10509a0"
    sha256 ventura:       "80caac371964f0b21498fdc59ffd60b82896b2e8bbb640acb049ec200fd01c39"
    sha256 arm64_linux:   "baf6811bce172b08ab17bf70be6d20075df33db91cd8a0b3476529d590f120a9"
    sha256 x86_64_linux:  "a1dae0cbe0ba46499542cd211ce00a349115b3493b918585813d648509300274"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnome-autoar"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libcanberra"
  depends_on "libgoa"
  depends_on "librest"
  depends_on "libsoup"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  # Apply Debian patch to support newer libsoup and librest
  # PR ref: https://gitlab.gnome.org/GNOME/recipes/-/merge_requests/47
  patch do
    url "https://salsa.debian.org/gnome-team/gnome-recipes/-/raw/76a3e12b3a77e76bf0c2bf894481d6b0284dd5af/debian/patches/Port-to-libsoup-3.0-and-librest-1.0.patch"
    sha256 "15a06b277d3961d4a00e71eb37b12f4f63f42c99bc1c1a6c9d9f4ead879d4c32"
  end

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    # BSD tar does not support the required options
    inreplace "src/gr-recipe-store.c", "argv[0] = \"tar\";", "argv[0] = \"gtar\";" if OS.mac?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"gnome-recipes", "--help"
  end
end
