class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.32/file-roller-3.32.0.tar.xz"
  sha256 "03283027f1b9747c5fc5747eb672e0c155023c7fd74bec7b8faeb7b7b071a7c5"

  bottle do
    sha256 "b8fbd6bf80150c9cd31fd6453f915041628c281c16833e8b43c07764bec191cc" => :mojave
    sha256 "cb871a853668327b61f38cc1d9358f24b6085349ea42248b3b184ee9bfff9a8e" => :high_sierra
    sha256 "0533e7a196c6c364894c5510cab68f598b092ec8891018a774f8b6c4e6b2f73e" => :sierra
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
