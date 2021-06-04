class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.18.4.tar.xz"
  sha256 "218df0ce0d31e8ca9cdeb01a3b0c573172cc9c21bb3d41811c7820145623d13c"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "d53193975b44bcf1cc770df6c7df5dec55c2a5813f6ede0b624d422aea132c94"
    sha256 big_sur:       "378fcd8eccf1bffe8148b8ddd6eae10ac34fab4b4719ab02f3301de3806a711c"
    sha256 catalina:      "47c0a93c8c1a818545a07941bec50103b9a1f61efd07ea3004be1e2183e63d23"
    sha256 mojave:        "49de7f4a66957c008f299f303702524f2c09f8e678173400b0050137df11f75c"
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
    output = shell_output("#{gst} --plugin x264")
    assert_match version.to_s, output
  end
end
