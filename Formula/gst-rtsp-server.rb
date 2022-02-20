class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.20.0.tar.xz"
  sha256 "c209f5ed906da713fdd44a8844e909aa6c8af3dfb630259b092cfb77a7755843"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "366d66c65b72e9fbdb198e6a7e3fa5394814160445f0ef7c5ec08930095873de"
    sha256 cellar: :any,                 arm64_big_sur:  "cab76c385728c4bed6f7424353378bfc53fdec9e20bba3571dac89918ed6e0e6"
    sha256 cellar: :any,                 monterey:       "6738798ca8d10fbf517786cd0904da358f4fa67d035ed72b4afe2298e36da1da"
    sha256 cellar: :any,                 big_sur:        "b1fd69a32bb4e2b8269cfe2cc455f46ddbbbddc6db3c4ebeb6e12357e97f2965"
    sha256 cellar: :any,                 catalina:       "24b89766d3d38b35b12b89add803ca04b8e7b42132646c82b59d9edd5c739fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c335ab4a0fa350335cdc33ea3d3192ecf816e9b935d17f7545cc2c4388b21829"
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
