class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/2.0/gnome-recipes-2.0.4.tar.xz"
  sha256 "b30e96985f66fe138a17189c77af44d34d0b4c859b304ebdb52033bc2cd3ffed"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "c3d2fe01ea97827e715cb29583797418cb4d71b00e6ee97d9f8dfaeb96bcf4e2"
    sha256 arm64_sequoia: "48061c558c7b2a4ac42a5a0fee09187c92323a1a3a261133edcbd765e07f16fe"
    sha256 arm64_sonoma:  "e474b3f42f2ae09b5282d78c7a18e88661c5b0d15d4e275f8cd0ed5fd323236c"
    sha256 sonoma:        "3aa31f8c5cd39076cd93675d43f487488832ed0a91036b01093a9f111c436ec2"
    sha256 arm64_linux:   "44594058f4bcf5667642ff19ac9976d4dd5e065953e157325221368cf769525d"
    sha256 x86_64_linux:  "dedbae7279b37281b9abf9707483ffde9f28ad37866541a883afe5207847b5fd"
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

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    system bin/"gnome-recipes", "--help"
  end
end
