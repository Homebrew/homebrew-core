class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.18.1.tar.xz"
  sha256 "18cd6cb829eb9611ca63cbcbf46aca0f0de1dd28b2df18caa2834326a75ff725"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-ugly.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "969988311f13eeed74f28e076b1224f2c0ff2d72f2c3aa0e80b25e47689da0d2" => :catalina
    sha256 "198d2784b617d9809be93951d5dc92b1808ec6e6dd88ec220477bc5b4bf24a46" => :mojave
    sha256 "b655213165ac066d0835dc6f12244e04ced5534fedc84a82e72a39bc2319fbae" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    args = std_meson_args + %w[
      -Damrnb=disabled
      -Damwrbdec=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvdsub")
    assert_match version.to_s, output
  end
end
