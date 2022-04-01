class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.20.1.tar.xz"
  sha256 "4745bc528ad7de711a41d576ddce7412266e66d05c4cfcc636c9ba4da5521509"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "3f07cf8f8ccadc25f8ca08bc6ca28eb730b202213159a695f88c1a6c0e99654d"
    sha256 cellar: :any, arm64_big_sur:  "4938cfeb25044272e87eb8ac3b11e2b930eba8f4f302bfc00e76c7d2ae0c884e"
    sha256 cellar: :any, monterey:       "236fa79fbafc218eeec32ec97a150cd5548b349b426f79cae72f818cdfefa044"
    sha256 cellar: :any, big_sur:        "fa02d18954bda4cad2053c3ed77c65379a3cd408a54c9927210ca4e9d189f703"
    sha256 cellar: :any, catalina:       "f4a80fdd7e5342ad4a7b3b02c13e46b8ffb9913558ae7d258fa82f6925233da5"
    sha256               x86_64_linux:   "52df28879b64e01d85c7fb506b2f2ffa301677608a931f95fb6f4c483c8d2d4c"
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
