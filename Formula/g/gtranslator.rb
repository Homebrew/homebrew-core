class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/45/gtranslator-45.2.tar.xz"
  sha256 "1c946110e6f19013c162a422ca17f1de944c5ab8c29e30389a0df9f33314c8aa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "56639c17c38bc6619b229bbf92ef417cbb5be0366ee421b633e0adee646040b2"
    sha256 arm64_ventura:  "adb4941369d05f7972c9b444210f22916c58acc15e8358a74826594202e98505"
    sha256 arm64_monterey: "9d66dcbbdde00352abe166e8414d9e50bbc5c83abb38ab7bab5e86df4de7256a"
    sha256 sonoma:         "72277e92042dfa982ab01387a9fa778f5fdb4e02dea71d9d0b8cc0d5390c0f49"
    sha256 ventura:        "3f97185c50b288e6a106a9cc8825c78eff1bff4541968d8935f8e18647970e8d"
    sha256 monterey:       "2f62c0ca0a4667dcd04d8f8d99cf7b181cbf8e7b410b0f9351e393efe5fcc6af"
    sha256 x86_64_linux:   "0403fd864304c79ca777c2d99974ee3c4cfbe7225b1fef6efadf1bb2ef08a4a2"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libgda"
  depends_on "libhandy"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gtranslator", "-h"
  end
end
