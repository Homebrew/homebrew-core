class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.18.4.tar.xz"
  sha256 "a46bb8de40b971a048580279d2660e616796f871ad3ed00c8a95fe4d273a6c94"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/"
    regex(/href=.*?gst-rtsp-server[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9b8dab026348a2348dfa8ab395fe3760b16fa595f15c80f4eeb7828fb89b80b0"
    sha256 cellar: :any,                 arm64_big_sur:  "0fd899f6268df8362cadf3f19b92753740301acaf2aa180a4d95f256cb40e4a8"
    sha256 cellar: :any,                 monterey:       "7d53dbc68b9682aedc0b4c7abbac2341d262480b91b883f3f5c108778be57f47"
    sha256 cellar: :any,                 big_sur:        "2cbafc9f96e6c7b87afac67edaf0c0252205307ee088066f2d3766807ebdc68e"
    sha256 cellar: :any,                 catalina:       "7528fe1df86bbd0c6702b3e4c843af6509640098c1cd5b5d326941c2006c503a"
    sha256 cellar: :any,                 mojave:         "1f69a3c5c02d021ebbb7e5a96779f38d15ffa3eef0680d993f3f5c508bbdb0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2502c56d4e31e2d562eb47c87977d090fafad4778383cc4c29586ac03aa7310a"
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
