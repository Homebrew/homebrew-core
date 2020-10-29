class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.18.1.tar.xz"
  sha256 "e210e91a5590ecb6accc9d06c949a58ca6897d8edb3b3d55828e424c624f626c"
  license "LGPL-2.0-or-later"
  head "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "640ea34d1d6a1677ef0d686c94a94c7f11fc51a3cc559f259a93a67829df104e" => :catalina
    sha256 "947085d8a2e20821863142835ed01c2194b5fc5f5215d1bce2a5305da600d177" => :mojave
    sha256 "a4ce36c20f484ae760bad584863b37d24d685f7418e459f9ce2e407d9ca3f458" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    args = std_meson_args + %w[
      -Dgoom=disabled
      -Dximagesrc=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
