class GstPluginsUgly < Formula
  desc "Library for constructing graphs of media-handling components"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.20.0.tar.xz"
  sha256 "4e8dcb5d26552f0a4937f6bc6279bd9070f55ca6ae0eaa32d72d264c44001c2e"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-ugly/"
    regex(/href=.*?gst-plugins-ugly[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "17d964846b2e566aef42536dfd1656e142b932d3f012ea35a12fc21caaf706eb"
    sha256 arm64_big_sur:  "1eb49d0508fea6b8b6cfc79320851f4218c58c965caa84fb3acb772d599dbb5e"
    sha256 monterey:       "a0a8716e0f2852b9801e491ce9358368aca40db23930d2469449af54ab25214e"
    sha256 big_sur:        "4d4929eddbc0d179821e23b1d464ba6b5e9016f8bfdc46d508fea492aa2d17c1"
    sha256 catalina:       "61c6247e61ea354c16b781fee374c907012f2ad11640ee4de99cbb15f5fb6c9f"
    sha256 x86_64_linux:   "dc83215500215a27139c960d14f91428aff6dd1f58fb687e770ad48372f8209b"
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
