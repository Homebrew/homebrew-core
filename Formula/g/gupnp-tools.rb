class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.1.tar.xz"
  sha256 "53cf93123f397e8f8f0b8e9e4364c86a7502a5334f4c0be2e054a824478bd5ba"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 arm64_sonoma:   "07d80564d377af0fd7aad93d0273482470a1cedec10e97b033ed3509bf64f5b1"
    sha256 arm64_ventura:  "1619dbcf3a1eaffc84bfbf7e94d920e3e3dec35bda74a08966808e586f042d7e"
    sha256 arm64_monterey: "c8f73c04a4fa8593a9b242b8179fab87db810485b8fcd11aa700d9a1b19b7773"
    sha256 arm64_big_sur:  "87bdd498311587e553d2af17ba4faac38a5c1be9bb45c4f82fab560968bbb9bb"
    sha256 sonoma:         "c9674d5255bf4dfbf2c7227476cfa834bee150ebc2c7442ce81f274560168c14"
    sha256 ventura:        "e9b4a96cdb94126fcc8429472cd9c671bb9684c3fd1b2892a6543624c27935de"
    sha256 monterey:       "c89097142ba2f4ee33854da2989b2da5634af587a26f478c4fbe7758156dce41"
    sha256 big_sur:        "208ce0504ebe71e7d1ba4f425c11046ed4df05733a370cbc73c83f0d4ca2ca04"
    sha256 x86_64_linux:   "22f34f77311bfc7559511959c8e6b341eaaeccbbd1a180125d02e83f50892a03"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gssdp"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup"

  def install
    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
