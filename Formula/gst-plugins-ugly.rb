class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.3.tar.xz"
  sha256 "8caa20789a09c304b49cf563d33cca9421b1875b84fcc187e4a385fa01d6aefd"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9906516c4eef3960519bb4aee31944725bf3adce316181f8dfbcb37f29f1e6e8"
    sha256 arm64_big_sur:  "30e89fa1798b9c66b3c0c7459c5167972080c676340505659ec54a9a5f5919ff"
    sha256 monterey:       "6327d03fbd94b4ba738ce3029c1b06331a2c5feb9139f759b9a9a20080880c8e"
    sha256 big_sur:        "0ca8223e200bc0aa150176ef28b0f8578fa6f7c89645cd07d7c2dd04c8c73de0"
    sha256 catalina:       "f71cde01b0fe4cc796e9f826fed1227ffd4c26890fbea481b077236842c3f0b6"
    sha256 x86_64_linux:   "cc112f30cff8222c9655a843dc0da475ddd06fe83bf8d32ffb9c2fe8c26181a8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "theora"
  depends_on "x264"

  def install
    # Plugins with GPL-licensed dependencies: x264
    args = std_meson_args + %w[
      -Dgpl=enabled
      -Damrnb=disabled
      -Damrwbdec=disabled
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
