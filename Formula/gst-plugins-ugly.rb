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
    sha256 arm64_monterey: "7b867439e878a489ba7711eeee5246fe11b22d45b6a31fa3bdcbe92262321dc8"
    sha256 arm64_big_sur:  "c26fcfcb00d379e78ca6ef6604bb6fbd2009a115f4539028ceb30ad285e4f5cb"
    sha256 monterey:       "4cefe0973223b6cadbcdc25c689c79b99ffd9f223c766fd084c70aba589b0a3a"
    sha256 big_sur:        "68e560c958f51b56fca506ecec7184eb9b7e5ff65975bea175b89a4356b32bcb"
    sha256 catalina:       "802a9a55d3b39fc00acb53a457bcc6cf1e94660c314d4560ffaba928191706d6"
    sha256 x86_64_linux:   "57829a3d6af878758e67e6f6fd5642aac37a6ed8f199a9e334599f796223546d"
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
