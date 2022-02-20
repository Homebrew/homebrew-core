class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.20.0.tar.xz"
  sha256 "4cb66fccf730b1037e6533862c2128990912a6db4e5bbd14e0ef914450eb4c7c"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "30ca2c483d53fb6dc7ef736f117d38f656f1c42599265c5c062465a9dcb67ae8"
    sha256 arm64_big_sur:  "24d9c4c3e469da3a3f06049924de4018f49fdd3c4cb49172e2396030d4dc52a3"
    sha256 monterey:       "8224b5894d255a57d8346f8cd50067f8c107bfe5d9fe155aa5f1cf6a13f7e41e"
    sha256 big_sur:        "9d6ce345011d18a70a2c5388b9dae08d8fe9df95fdbe12ce7cd0a6e704f03b30"
    sha256 catalina:       "ca3dd9389dba3c782bde7ca1097cc216a00542fd17a0a05b19371c26a54f1c14"
    sha256 x86_64_linux:   "4619b056143e59a6e726a9fbabceddafd9927980a23912b95879e9bb7d6952ec"
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
