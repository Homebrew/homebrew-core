class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/2.0/gnome-recipes-2.0.4.tar.xz"
  sha256 "b30e96985f66fe138a17189c77af44d34d0b4c859b304ebdb52033bc2cd3ffed"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_sequoia: "e6384179a8520296a354b16a713f771ce12005fae15e20b04cad20d70ab78249"
    sha256 arm64_sonoma:  "26db0d944ceb54fe93dae2eda5d59e8e6d1e42b379d6ace92bc4c8d91c103423"
    sha256 arm64_ventura: "8d4546ce3489e1abd91c8b8e041e9d45abd62e9544406c2a0d8db793ab4ff845"
    sha256 sonoma:        "91887470bc686dd30fd50ffda8d7b77fb1c641ce2b82332355c17cd08e363655"
    sha256 ventura:       "5f5da99ec97f1dc810806d10dab0e7ca7f1efd274acb24964f434908012e3912"
    sha256 x86_64_linux:  "24c8b3034d9679e5efe8db3197a10de7e3a810d91f5fcc1557d9a2aed3f4a684"
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
  depends_on "json-glib" # for goa
  depends_on "libcanberra"
  depends_on "librest" # for goa
  depends_on "libsoup"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  resource "goa" do
    url "https://download.gnome.org/sources/gnome-online-accounts/3.52/gnome-online-accounts-3.52.3.1.tar.xz"
    sha256 "49ed727d6fc49474996fa7edf0919b21e4fc856ea37e6e30f17b50b103af9701"
  end

  # Apply Debian patch to support newer libsoup and librest
  # PR ref: https://gitlab.gnome.org/GNOME/recipes/-/merge_requests/47
  patch do
    url "https://sources.debian.org/data/main/g/gnome-recipes/2.0.4-3/debian/patches/Port-to-libsoup-3.0-and-librest-1.0.patch"
    sha256 "15a06b277d3961d4a00e71eb37b12f4f63f42c99bc1c1a6c9d9f4ead879d4c32"
  end

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    resource("goa").stage do
      system "meson", "setup", "build", "-Dgoabackend=false",
                                        "-Ddocumentation=false",
                                        "-Dintrospection=false",
                                        "-Dman=false",
                                        "-Dvapi=false",
                                        *std_meson_args.map { |s| s.sub prefix, libexec }
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    # Add RPATH to libexec in goa-1.0.pc on Linux.
    unless OS.mac?
      inreplace libexec/"lib/pkgconfig/goa-1.0.pc", "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

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
