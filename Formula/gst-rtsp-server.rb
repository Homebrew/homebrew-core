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
    sha256 cellar: :any, arm64_monterey: "393131e0d3f25db955044a19ca924f81f8df72221ec9ba1733892b8d47a1f756"
    sha256 cellar: :any, arm64_big_sur:  "fce516d079fe95c44401c0d4050940d0c6c7152c4224ef2b35fb43278f71676c"
    sha256 cellar: :any, monterey:       "ae3701b34e74a0166d2d5a8118ac9841646f66de7a17852b6ec785c153b03994"
    sha256 cellar: :any, big_sur:        "f052c6224f2f03ba3ff2567e317bdff3e3e8caa06c34939d9029ae973555a67a"
    sha256 cellar: :any, catalina:       "fd6f7fe3a362526b56b7e115ff52d57978cf7bc0da6c2b3c74a99e11ba6facd9"
    sha256               x86_64_linux:   "9887ebba0889a6fb6fa48bdae86da122edf28bc294befefbb8b010e89da46c0f"
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
