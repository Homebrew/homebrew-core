class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.20.3.tar.xz"
  sha256 "bbbd45ead703367ea8f4be9b3c082d7b62bef47b240a39083f27844e28758c47"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "def50d0cb223897a3eb61986e6a47c9738e2a070863d53976cf99ab11bf8c4e1"
    sha256 arm64_monterey: "3095ec9f22237b0c5404954ac1ff5200040eed7917b182229c31324250cc4b75"
    sha256 arm64_big_sur:  "9d0bf56c0adaafd48d91edcd36ed78de13acf92100471af791a6b9f3b49f1789"
    sha256 ventura:        "e33ccbd945ec00ccc134fc262ae34fc30c0e895795109e9ab397b2ce0528a423"
    sha256 monterey:       "0358177078512fd1bde0aa1ec4d4bbf1bbcfa7578ed522e463ab707902c85cc2"
    sha256 big_sur:        "f03b752496981a59428124478fc5dc1595137fbf8d69a3130fa2d19602801eb4"
    sha256 catalina:       "cd0dc00c2cef759be7c1bd4ec6efd81f14258ac781696f457d80ec37fa9b2972"
    sha256 x86_64_linux:   "c3e9c440677b235ea209c56435a95737a8a8422c2acf77d0b87d4f42395b8697"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "json-glib"
  depends_on "python@3.10"

  def install
    args = %w[
      -Dintrospection=enabled
      -Dvalidate=enabled
      -Dtests=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang detected_python_shebang, bin/"gst-validate-launcher"
  end

  test do
    system bin/"gst-validate-launcher", "--usage"
  end
end
