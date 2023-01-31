class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.22.0.tar.xz"
  sha256 "aea24eeb59ee5fadfac355de2f7cecb51966c3e147e5ad7cfb4c314f1a4086ed"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e47e470acefcb067ef8cccf6c5639d7b6c4979a3efcea8c010a38c9f0a658976"
    sha256 cellar: :any, arm64_monterey: "2f1219bed176985b107f9a2f6a9bba2c7a47a40d052c9737a234c18676b57231"
    sha256 cellar: :any, arm64_big_sur:  "5784bf22c6403330aeebf975687c6d95b856d33c573ecf9e7937e4efb804b37b"
    sha256 cellar: :any, ventura:        "bae460b8316bc6228e33ae397c9a4dc46c701cd233c2b0532eb4ec45c2676fcb"
    sha256 cellar: :any, monterey:       "e11484178e476a53923f4ebaa697362cfdcdd356b2a1af1b95cbfb4371e8f7ec"
    sha256 cellar: :any, big_sur:        "329f21ce2c46edcdd02cd4463f095f07cbd21b345ee6481a2fe751e89ed5adc9"
    sha256               x86_64_linux:   "f7833a7903f9f5b5c52874d8a0141acdd5cbd74d3b098336d568156b9293f9bc"
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
