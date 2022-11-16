class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.20.3.tar.xz"
  sha256 "7e30b3dd81a70380ff7554f998471d6996ff76bbe6fc5447096f851e24473c9f"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0121a568cb22aa9f13eadc5a50eed1732756fded1af90251925acdc1fe19f04a"
    sha256 arm64_monterey: "c1a84cb8bde6d9712aedc62e34bcd55d261a9a30e6605df13fd73ff329aadb8c"
    sha256 arm64_big_sur:  "c9751148a9a4d358b6a51cf55559604586def33b232615bab251e3a9be361209"
    sha256 ventura:        "b62f2f26c3269ea43a65ed1878b824a24dbc72139c83ce7cf54276b9926a51ff"
    sha256 monterey:       "4e02f656481a12ce1b5965c845e3549414d40e1a6328da8a33c2646df49ceccd"
    sha256 big_sur:        "588eeafd981aa2848f9b9b5229f52db91087e4ba308ffacd45690dff2c517566"
    sha256 catalina:       "84247feeb432bdd15f729406e5ee1d8d5fcc597c553453d48d56482dbd26e3f8"
    sha256 x86_64_linux:   "9006e77c75abbd33f8050b1a90d8fde5da095485694843ac73f315bb4d1505de"
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
