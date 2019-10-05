class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.32/file-roller-3.32.2.tar.xz"
  sha256 "c60a79e0baf74cb1c09a1c8f5ffe0d6e311227ca14ecc5b1156beb3715341a71"
  revision 1

  bottle do
    sha256 "962dbabf7ae9382f010883b9dbae5954ff8b718d345069ebf048a4d56c142927" => :catalina
    sha256 "fd7a817f48d8e7e94adfefd201246444df63e1faf1124a9a514844be41d68399" => :mojave
    sha256 "203f3e0746d109318d6f35620cb06f8bbf76b651234eb05594f469acb795fde9" => :high_sierra
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
