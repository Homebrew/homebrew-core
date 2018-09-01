class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/2.0/gnome-recipes-2.0.2.tar.xz"
  sha256 "1be9d2fcb7404a97aa029d2409880643f15071c37039247a6a4320e7478cd5fb"
  revision 6

  bottle do
    sha256 "7e43f9bf6e1195b10cae436af57429908ae4e6fb7686ac8b3ac1c7df41bbba23" => :high_sierra
    sha256 "078cd939f7da09bb99f11b8587376a3988ae6677e12951aa0dc0710165428183" => :sierra
    sha256 "42047634605fc4712aaf5aad6d64a157ed727d0be5bf6faaae334572d1420394" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
  depends_on "python" => :build
  depends_on "gtk+3"
  depends_on "adwaita-icon-theme"
  depends_on "libcanberra"
  depends_on "gnome-autoar"
  depends_on "gspell"
  depends_on "libsoup"
  depends_on "gnu-tar"
  depends_on "libxml2"

  # dependencies for goa
  depends_on "json-glib"
  depends_on "librest"

  resource "goa" do
    url "https://download.gnome.org/sources/gnome-online-accounts/3.30/gnome-online-accounts-3.30.0.tar.xz"
    sha256 "27d9d88942aa02a1f8d003dfe515483d8483f216ba1e297a8ef67a42cf4bcfc3"
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
