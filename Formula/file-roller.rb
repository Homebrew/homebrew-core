class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.36/file-roller-3.36.0.tar.xz"
  sha256 "b9144de8f536f583ec29d703c2c170bf2d00c6c166cd5e3f7efabda551f10478"

  bottle do
    sha256 "aedbff97f1b074de0bea4ccd5717695c7d6ca00fe80a187b1b386952d791da1a" => :catalina
    sha256 "404b85fa90759193b42355d01aa22d83cf552d9f9802c6bb4555e842ac30fd1c" => :mojave
    sha256 "c128d93fa4886cfe7ecdb497546827a662ba40b25c36c24dc83c6392da1af98e" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
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
      system "meson", "--prefix=#{prefix}", "-Dpackagekit=false", ".."
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
