class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.28/file-roller-3.28.0.tar.xz"
  sha256 "c17139b46dd4c566ae70a7e3cb930b16e46597c7f9931757fcab900e5015f696"

  bottle do
    sha256 "0f6ed9638357c88ec9e063f050f9602987f408f858d11f96ede54a889e9fb6ec" => :high_sierra
    sha256 "527d3641639115a94e2cda64a7804d603a5c72cffff43fd3c12c32ed4b78ccba" => :sierra
    sha256 "846f18e2a5785cbdb3acb87f86dc375a3362c0acf403888d989417a841912c4c" => :el_capitan
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
