class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.22.0.tar.xz"
  sha256 "582e617271e7f314d1a2211e3e3856ae2e4303c8c0d6114e9c4a5ea5719294b0"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4a800b1a39e7518602cb21296c08abdb1dcfe7ebed920ef2cfd580b0dc2d6ce1"
    sha256 arm64_monterey: "c4d2abbfe6114eaf0142c89de4ba7d9df1800a121c0267abc9f61ccfc807f87d"
    sha256 arm64_big_sur:  "33e08e490fd95c80f3b61f026e954f3437e8d41ded16b92e185c3023089b92e5"
    sha256 ventura:        "a26420de45ac87f6b0e6d608b79c94fd5810aed64bcb71035129ecae694c18be"
    sha256 monterey:       "2ea532a30b271aaef446a5fc883855cbc9476e3800e21f7aa5d64f4542ee1f00"
    sha256 big_sur:        "63f7876ebcd70e73c444e7d0732a7df5b3681894cb9720d8b7e0985f2fd3ad39"
    sha256 x86_64_linux:   "5e21be50ff33e1b80ec6fe89c5471f017a037ebaa3bf0df858a126c8528e2f35"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    system "meson", *std_meson_args, "build", "-Dgoom=disabled", "-Dximagesrc=disabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
