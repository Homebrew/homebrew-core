class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.22.0.tar.xz"
  sha256 "582e617271e7f314d1a2211e3e3856ae2e4303c8c0d6114e9c4a5ea5719294b0"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a1aa81cabe957c407d7679ac939d5f31048582c42f252bda08f87a4b7d140c71"
    sha256 arm64_monterey: "3c80e9ed3b66a12ff3dae5eaafc67571ef8f861bb24fe6d45590c42105019686"
    sha256 arm64_big_sur:  "81448a48c9779399c79a24a8e8d1818f25bf6b40b8b04503aced3a9a86b9d4cc"
    sha256 ventura:        "ec4d435e3b81e762fe1f01c131ce4da5b90b6bd6e13194ef8ffb798a8fcd05a8"
    sha256 monterey:       "b6e786de63649e1713a28edfc8b57fd56cd892b9d4e4b40cbb74124fa5887863"
    sha256 big_sur:        "d9dcaadfaa3bf955efa0ef4fa521204c3164e35ea02aae0dd18e0217f09256ea"
    sha256 x86_64_linux:   "1dbbe80d68b14b1b1c080dfc04280b990ce76e246b6be2f6f98c512df1ebd548"
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
