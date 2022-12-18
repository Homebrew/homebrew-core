class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.20.4.tar.xz"
  sha256 "88d9ef634e59aeb8cc183ad5ae444557c5a88dd49d833b9072bc6e1fae6a3d7d"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "28b0061a9d53963c72f2e7b5e54732f99ad879d96e1feee890e83340d0c903d6"
    sha256 cellar: :any, arm64_monterey: "90a81b846111c1db567d317b815bb6efc564483ad575a6138f72d8783e6f8784"
    sha256 cellar: :any, arm64_big_sur:  "f08baa8c08ebe29ad326a560a055f645d3b8f7db64436a5ab2032a70ed379a4c"
    sha256 cellar: :any, ventura:        "d76a2514d0f1d9828418aaf12e61c1b0f421aae90198f4675b6614e7feb4bdca"
    sha256 cellar: :any, monterey:       "28f1609e63622117d9852473cfdb928a49d42dc83aa6245b2847dc5d2e950329"
    sha256 cellar: :any, big_sur:        "260e025c8a41886fe63f4c8efb71c5ebe260a89233fac51dacb560dc5a4a07e3"
    sha256 cellar: :any, catalina:       "df71c3fc2210572f2f6d7be6568ee599f75d2ac4747826e727dc14b2a59f4c3a"
    sha256               x86_64_linux:   "89dbd844a505aaf257ffff2eb5bd299352767d4a65a0c6da92812cd4d19d2818"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dexamples=disabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match(/\s#{version}\s/, output)
  end
end
