class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.36/file-roller-3.36.3.tar.xz"
  sha256 "0959e10a5d7a7442809624be9879d95db462ca76e8c66ad6299310e6acdb81b7"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "cb5891624ee410f126068ff1e6ebae88c86d98b50d094c9e348262f5e2e4a622" => :catalina
    sha256 "7e67ba40959e65fa8253acf762fc3430e27f054f35947cc54cc320ca8306cd2d" => :mojave
    sha256 "7f6d54ab8c0e99d1516661386e841199ad4627522bbbe5485c2acd0f64f94270" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libarchive"
  depends_on "libmagic"

  def install
    ENV.append "CFLAGS", "-I#{Formula["libmagic"].opt_include}"
    ENV.append "LIBS", "-L#{Formula["libmagic"].opt_lib}"

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    mkdir "build" do
      system "meson", *std_meson_args, "-Dpackagekit=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"file-roller", "--help"
  end
end
