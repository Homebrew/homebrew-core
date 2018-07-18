class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.28/file-roller-3.28.1.tar.xz"
  sha256 "574b084eaac142357f54419f8406b029038059845eb16b05eb8e314d2b5dc227"

  bottle do
    sha256 "dc131fb4a57b17de6f6d6541d2c0376b363be969492ee294545180d5e3e304d1" => :high_sierra
    sha256 "b6e43d46515f1a99c6d483e5ead0cce4759eebdd8b43c9fb104dd8b2067ad5d1" => :sierra
    sha256 "8b8025260e526e13c853a6fd0dfe37b9fda89ed3ef4943f0fa0b7b4925826bd4" => :el_capitan
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
