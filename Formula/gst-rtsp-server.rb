class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.20.2.tar.xz"
  sha256 "6a8e9d136bbee4fc03858a0680dd5cbf91e2e989c43da115858eb21fb1adbcab"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "69572557f39914c0e59873074561f376ec535a0b7c70e6cc9fb8c454d6a9720a"
    sha256 cellar: :any, arm64_big_sur:  "d544a9df0b76784ee6a7d79e61f4eb9e04fa496cd56648d33125e695790f234d"
    sha256 cellar: :any, monterey:       "7463c3d82bc7edf073d3f8e7e5d9b92e036072f0d5a023b4ac7afb8603c2b03b"
    sha256 cellar: :any, big_sur:        "69156454fd9ac5945ceb4bdedbd86faeeb58282505b863865a096ae5fb6c4869"
    sha256 cellar: :any, catalina:       "1ae8e35a2359dd1105836fddb36552d7097049908459ee256debd83011f06b78"
    sha256               x86_64_linux:   "4c2db5bb0b5755e8ff8b3921211c2d9fe35146161910965d91441f4ea46a6bce"
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
