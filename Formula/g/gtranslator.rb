class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/46/gtranslator-46.0.tar.xz"
  sha256 "0a30bf0fd82d88f9a206659e8b5f59eaa93fb80f67530bbf9461c5bf6a1c0beb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "c3aec870cba9a26a2c1502bb869d897507f561598aae8f33e52b5cd67d1a0916"
    sha256 arm64_ventura:  "f61d1c7b389c657772f13a98c1570712363f9ff5e34a14cc77ba6efcfcb92a0a"
    sha256 arm64_monterey: "175c4f43fbcd01432c50c97aaa89a575fab1929375bd58fb8744f835e5880661"
    sha256 sonoma:         "a4ad0b2b63cbab5ed8be710d95f0ba4a19354ffb9cf9a6ab639f4a1ef5e6ee3c"
    sha256 ventura:        "359a9191f2669986dd391d81a3a0309cd0d64ff0f68d055ae82e91f2b6a520b2"
    sha256 monterey:       "61727b32df792e2f5f8bf6ea99436dd713dcda77d08abd42bcf2c378d890b216"
    sha256 x86_64_linux:   "912e28944db7258f1fc4808d7f7997273046c44f6da573011ae68192623fa67f"
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
  depends_on "libsoup"
  depends_on "libspelling"

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
