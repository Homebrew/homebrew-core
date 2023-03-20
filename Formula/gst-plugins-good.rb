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
    sha256 arm64_ventura:  "72cd2f3fd1f042e81f13e8e3e0b3bc89b0c960976ca69da0878c9a4a814c7c6b"
    sha256 arm64_monterey: "d0813248b5b9293d87f4617659f03bbd0dd99bb72cb373d6b296b4afd0129c7b"
    sha256 arm64_big_sur:  "d96eb9c033d6cad185ee3a18283d6178043da7e801c808895bd83db10e833f77"
    sha256 ventura:        "5a6bffefff50a1e5f2f30dbecbe66de8579d92d608e9df55f96e667265320344"
    sha256 monterey:       "53d3a38784ae703469de43f64f8a112835c73747e1a8a44a2b07524cc785edcd"
    sha256 big_sur:        "6508f010cdfdbcdc2b1dc835b0071679245a60a5d26a3d3f46c090f6c84fe062"
    sha256 x86_64_linux:   "c0e1873162c0f7f52e0c8e612a1897c3c50cf8740f2a6291fcb70dc512c698ee"
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
