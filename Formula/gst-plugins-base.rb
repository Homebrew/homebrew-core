class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.20.2.tar.xz"
  sha256 "ab0656f2ad4d38292a803e0cb4ca090943a9b43c8063f650b4d3e3606c317f17"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "192c48ab5422270a4c1dba543b97efb9948b0a728f6e1a6b48e0ba0964038fc1"
    sha256 arm64_big_sur:  "19483c72ceff5a121f1fe58a17b9926ad564c85f043fab679ae7d08c79e79330"
    sha256 monterey:       "d134fdde283ef8464b64d8505976b860c8294429b7736690f2b41a33c83237e8"
    sha256 big_sur:        "36282774109597bda621460e8e94d94b509e12c940a43b4a44fc177d62075eee"
    sha256 catalina:       "69e13cb71ed79760658b71fc74e9ce43f83be6c024b383ad8c07cbde1736e270"
    sha256 x86_64_linux:   "70aff95c90a5edf7a1c7832abf7f93be6977387b612ffcf45c4d72ef190a49e6"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "graphene"
  depends_on "gstreamer"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "orc"
  depends_on "pango"
  depends_on "theora"

  def install
    # gnome-vfs turned off due to lack of formula for it.
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dlibvisual=disabled
      -Dalsa=disabled
      -Dcdparanoia=disabled
      -Dx11=disabled
      -Dxvideo=disabled
      -Dxshm=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin volume")
    assert_match version.to_s, output
  end
end
