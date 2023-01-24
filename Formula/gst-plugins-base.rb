class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.22.0.tar.xz"
  sha256 "f53672294f3985d56355c8b1df8f6b49c8c8721106563e19f53be3507ff2229d"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a3a353c76189f1ae51e6b4c046f85d2251264ebb37e5023ea06a62809025d773"
    sha256 arm64_monterey: "c21b4a8e6cf09a43cb574da9a4b99d705189c9d01ecd51d4ff87494551ea4a7e"
    sha256 arm64_big_sur:  "0bd6be3f07c5cb0ecc88b8c167187e5aa632500d52f8f9342f6f722973a16321"
    sha256 ventura:        "7d0fef276f2f82fcf1e92d583f7d21c4c5c66104bf44fa7db1de6551a5fb97df"
    sha256 monterey:       "8beb288ad29abd319a42ca436b01a13bc6593f768551de4498e786e1a4ce5b03"
    sha256 big_sur:        "e614558a1b1e1d72a17120324bf07d8cba86f39dabdf76c57b300ab24e6181cb"
    sha256 x86_64_linux:   "0dc7e6a058682b1476aa7014020c5edb8d95f201311b9c898293be123ac3de8e"
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
