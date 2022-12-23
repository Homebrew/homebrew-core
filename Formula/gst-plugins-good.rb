class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.5.tar.xz"
  sha256 "e83ab4d12ca24959489bbb0ec4fac9b90e32f741d49cda357cb554b2cb8b97f9"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "96eb78c30845c6bf6dd91b34f97a8795774e05a955d13d15a9a07e2c51a93ccf"
    sha256 arm64_monterey: "e3e036bb54e0d187b6e911c038a05b176f0b26248cdd0966642a83f62394e1c7"
    sha256 arm64_big_sur:  "60a4939ccd188ae2f2eb1135edd2b2916b635c26bc59d5c6515c819701910ead"
    sha256 ventura:        "88810322dca5efc14628d79f5947e55c19446ba29001ec52e155f67cc5498d09"
    sha256 monterey:       "f0872dc4d4918d46bca159ab436de3f89e3870978ebd33a569ac3bc0eeccf259"
    sha256 big_sur:        "279d0e78e80e1f786e81984226280e1c97af5feb523844fbc3df5b33018bc3c2"
    sha256 x86_64_linux:   "8e24010f500339741c6d890d52450069390740f6b6d116186d05d132f6da5aa9"
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
