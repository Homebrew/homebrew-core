class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/3.40/file-roller-3.40.0.tar.xz"
  sha256 "4a2886a3966200fb0a9cbba4e2b79f8dad9d26556498aacdaed71775590b3c0d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "9ad85c8aff2edef202726c8cc88913adb8c665e2f044c4f76b60107512767eff"
    sha256 big_sur:       "05bb1f323b1b1f095e17db22d4df0dedd8445d8b1acae02d61e5e5ea090e4d2b"
    sha256 catalina:      "39ee8ce6b01db0f4d78a39ad6f1522c39de262a8e9fd05483d64194ebcef8453"
    sha256 mojave:        "32c79439711f60b47b4d5e19ae07f74955f921061872ff4143f984f4f78ad460"
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
