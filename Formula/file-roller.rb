class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.30/file-roller-3.30.1.tar.xz"
  sha256 "41de44cb85607511cc7bbc9496ba241e714b180e671d724ae8be478ff553394e"

  bottle do
    sha256 "f295f376988b74dc42a3185677819afceb662471ea647e0655c5cae73f7f4ed8" => :mojave
    sha256 "052246a8799e0d10a9bc545911b25f280559a0246fcc612f7a3f0e5dff64de3c" => :high_sierra
    sha256 "99b1d9035dfe548389701946fe7966b57684f5d71f8c60c38afd17afbfa63e39" => :sierra
    sha256 "6f81289357b9cbab497aa47493934effd1952654f1fadf13c7529f4bd83c2c36" => :el_capitan
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
