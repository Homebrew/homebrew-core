class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  # needs submodules
  url "https://gitlab.gnome.org/GNOME/recipes.git",
      tag:      "2.0.4",
      revision: "d5e9733c49ea4f99e72c065c05ee1a35ef65e67d"

  bottle do
    sha256 arm64_big_sur: "a383ac85885a09d8c959af00fda8ab9fd6599b4347ce26929b6ed67bf9735e05"
    sha256 big_sur:       "c0ad5482453faf871b12613b8d6a6e9c2ae5762ed14513ff96e941645822feb6"
    sha256 catalina:      "57c8af5693a567947ea106732c61bcb30e867118dddc79c17856a0b226ee93da"
    sha256 mojave:        "4c3c1df208cdb1114858b1760fa0db2f606c9c5d999d2cfee9a483a519681cde"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gnome-autoar"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "json-glib" # for goa
  depends_on "libarchive"
  depends_on "libcanberra"
  depends_on "librest" # for goa
  depends_on "libsoup@2"
  depends_on "libxml2"

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

    # BSD tar does not support the required options
    inreplace "src/gr-recipe-store.c", "argv[0] = \"tar\";", "argv[0] = \"gtar\";"
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    ENV.delete "PYTHONPATH"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
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
