class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.12/gupnp-tools-0.12.1.tar.xz"
  sha256 "53cf93123f397e8f8f0b8e9e4364c86a7502a5334f4c0be2e054a824478bd5ba"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_sonoma:   "b832bd754f0cd4821f07a2e4556dba4467547fce6349fd6ba94d9d94e07bd3d3"
    sha256 arm64_ventura:  "f904ad26e367038de7e62d3225dbadb45d5ecc92576522c9cccee555b3b09ca5"
    sha256 arm64_monterey: "a39bd9b1a678af3d0d27c68ed8be15672c0bd67226e69cef83b6f7ce573cc84a"
    sha256 sonoma:         "0ea8c6cfc95af42593b4fd26d7a8d3fb9144a047a987f340c526385182fd73aa"
    sha256 ventura:        "1bd809d560c4a5b64932ce1b8e2961c22a82f13a0b8319c520c358ffa44037b6"
    sha256 monterey:       "100acb67f8f3093207efece8e95ed53d5308f2c985eea3c7f58bc2f02cf77958"
    sha256 x86_64_linux:   "53ee8f67fed3bb529c2b44ab34c6bacc2bf2ca839fd1147c02e4a5456f1c411b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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

  # Backport fix for libxml 2.12. Remove in the next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/gupnp-tools/-/commit/4e06104df81fba2cda06d4747b33e75f4cade458.diff"
    sha256 "a7e5c3ebf6dfd98fe17825b66b57ee40c839c19878261749f436676466faa945"
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
