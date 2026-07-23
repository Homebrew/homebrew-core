class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.4.tar.xz"
  sha256 "2c7f6f538fb36a15322be532217e5de161182c943c0a8b0da4458cf970b4092f"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 arm64_tahoe:   "1f8c360d4f56cd627694c21e3509cbf0d1701173209cb3edfb16ac097943b134"
    sha256 arm64_sequoia: "ae5404b7b818841b847afe4e35efa62ea6a80dd913a883ff3a9497f917adf107"
    sha256 arm64_sonoma:  "46316d893d7e940ce3668bd28dc2f0c36e8175912f7899e4dfb3de6e5e199057"
    sha256 sonoma:        "fe4d6cf65324bd8a15c03b41d5effa1bc9790a8f4ea05eee71982038d2439056"
    sha256 arm64_linux:   "c5eac35732988ece280ca3feccafc85148f3eedf81698535bc10fd5e58a7352d"
    sha256 x86_64_linux:  "7d506830e37f84b41996947133d30d5363fcdc367403d06c7db627d70cbf6e1a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup"
  depends_on "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gupnp-universal-cp", "-h"
    system bin/"gupnp-av-cp", "-h"
  end
end
