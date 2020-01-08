class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.32/file-roller-3.32.3.tar.xz"
  sha256 "be111fb877dc1eb487ec5d6e2b72ba5defe1ab8033a6a6b9b9044a2a7787e22a"

  bottle do
    sha256 "e858c664fbc54e0d9852f5ffcf02b3728706a1a2b1556f48a657bb852edadf11" => :catalina
    sha256 "62ee2117ab1cbecf2e14d67643fc46cc49523cb6c3dfa9528f0e5bb52dd03c28" => :mojave
    sha256 "a12f186d41652b69905d08857a6d7047dca80f821df1d7941a10d11d37787b3d" => :high_sierra
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
