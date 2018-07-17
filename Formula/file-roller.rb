class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.28/file-roller-3.28.1.tar.xz"
  sha256 "574b084eaac142357f54419f8406b029038059845eb16b05eb8e314d2b5dc227"

  bottle do
    sha256 "d7abde518cde71c0560862adee45af2d50ba7680f706969bd4336342a7348d8e" => :high_sierra
    sha256 "837a8976176c65b2746324224cc839aa1d06e4acc5b33a1ea182569feaa589ea" => :sierra
    sha256 "0b2ffcb564df4f03c429f8b8c0f7f19afe7e0e8f73a706471005fdff98a25dee" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libmagic"
  depends_on "libarchive"
  depends_on "hicolor-icon-theme"
  depends_on "adwaita-icon-theme"

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
