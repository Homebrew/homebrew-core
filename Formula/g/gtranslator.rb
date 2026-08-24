class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/50/gtranslator-50.0.tar.xz"
  sha256 "857b51c78f54df42418ff6fa9e62b8554df7f021cb12338c1fc0d85b99c918ef"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "1dcfec8e7d915866f4e76862ad7b03be26f72d246b03772291ba38b62d96b7eb"
    sha256 arm64_sequoia: "d5d806c4e21889f9beefe7ab79b8e4960c127aa883dd836742590cb12b8265d1"
    sha256 arm64_sonoma:  "cc32c2d59b825697c8d8e2a30facf7fef6a39574dda8bf1e8e273a4b8d4b5058"
    sha256 sonoma:        "47c3ff14f787a675a203bebab85aced943d2ab7402bb8c6a6afc7dac17b1d7f9"
    sha256 arm64_linux:   "61547a20cc62e78d3c1b770d885b9d1338638dfed2306282043d77533092f43f"
    sha256 x86_64_linux:  "d7b43a77a44f936920ed8f99a81118d3f5b2435308f502ae4bb06fc9ed5a8bdb"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "gettext" # needs libgettextpo
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libsoup"
  depends_on "libspelling"
  depends_on "pango"
  depends_on "sqlite"

  uses_from_macos "libxml2"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    system bin/"gtranslator", "-h"
  end
end
