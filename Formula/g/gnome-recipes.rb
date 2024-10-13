class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  # needs submodules
  url "https://gitlab.gnome.org/GNOME/recipes.git",
      tag:      "2.0.4",
      revision: "d5e9733c49ea4f99e72c065c05ee1a35ef65e67d"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sequoia: "aeca025b7378f47ce41dc347deb424d0944de6e7da3408c6e775570ec25a321c"
    sha256 arm64_sonoma:  "b65f11b25c9f58fa146f4a60b1c8ac1f1f807ffb48c91234b73736ae9d8d3ad6"
    sha256 arm64_ventura: "839f681efb2bc6d86d2c399a1bb4236f852a177f0c1899b65580a5ef55511acb"
    sha256 sonoma:        "056abd76e963efbe48a5459b8a0a6c7d97b51efaacdd4ae7ec401c1c433e1f58"
    sha256 ventura:       "cbb8cda97c299ad0c43bc5536923992ce0aee73ce2757956c17d477e588de34c"
    sha256 x86_64_linux:  "0cbf9ab64b5ab37f4ea338f445b5f53d50ee6cd5cf91d66da1bdd348a3982775"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnome-autoar"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "json-glib" # for goa
  depends_on "libarchive"
  depends_on "libcanberra"
  depends_on "librest" # for goa
  depends_on "libsoup@2" # libsoup 3 issue: https://gitlab.gnome.org/GNOME/recipes/-/issues/155
  depends_on "libxml2"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "enchant"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  resource "goa" do
    url "https://download.gnome.org/sources/gnome-online-accounts/3.43/gnome-online-accounts-3.43.1.tar.xz"
    sha256 "3bcb3663a12efd4482d9fdda3e171676267fc739eb6440a2b7109a0e87afb7e8"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("goa").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--disable-backend"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    # Add RPATH to libexec in goa-1.0.pc on Linux.
    unless OS.mac?
      inreplace libexec/"lib/pkgconfig/goa-1.0.pc", "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

    # BSD tar does not support the required options
    inreplace "src/gr-recipe-store.c", "argv[0] = \"tar\";", "argv[0] = \"gtar\";"
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    ENV.delete "PYTHONPATH"
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
