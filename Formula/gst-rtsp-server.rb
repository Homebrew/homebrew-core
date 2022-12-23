class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.20.5.tar.xz"
  sha256 "ba398a7ddd559cce56ef4b91f448d174e0dccad98a493563d2d59c41a2ef39c5"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "23fd0c66480ad245cce6785b1b7fedf3ebb947b5d65cf7642a23d3a281dd894e"
    sha256 cellar: :any, arm64_monterey: "751a8c5d2f1186e1383c96f57b1b919607158548643b357c5bc2bc0745b5ddd6"
    sha256 cellar: :any, arm64_big_sur:  "f225c54ede1e22e013974656eb8c513a1341765cd57923bb693b0e922c024d9f"
    sha256 cellar: :any, ventura:        "a3774dcfba5791270bbfc058f77de49749c042cd8d2c2c8cfc512265109166a1"
    sha256 cellar: :any, monterey:       "9c0f7ddd940d9deebb5a980c34577c587f3f94a5b83270fca6f34ea31f2d98a9"
    sha256 cellar: :any, big_sur:        "aebf8008df27ff754f3d128c2a96a3e5a15a16888bb7ed3b90c766cef88b2cdb"
    sha256               x86_64_linux:   "1c02e0712c03cce73eb3cdd1e55d0573f9f280e4bfb8f25987c95679caa8e366"
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
