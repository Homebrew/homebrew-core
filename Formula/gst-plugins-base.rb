class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.20.1.tar.xz"
  sha256 "96d8a6413ba9394fbec1217aeef63741a729d476a505a797c1d5337d8fa7c204"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "37f0d393ed4b4ec8b59b89a14ffea7717b40e7b7fc7b5bee2ddb4076c9d2eb72"
    sha256 arm64_big_sur:  "16d40c9acd2e924aeaa92d9e7ec90cbcd04846d99c21d6d9c1dc1cad2ceffa2e"
    sha256 monterey:       "9268bd9d9e96f34458c6ef991018bcc1e46f2b326b42c212a2f23ab180e06097"
    sha256 big_sur:        "b88b960835fcb2c98579814ed594ede012f86c1205f09e89fae4a2f8a698ba65"
    sha256 catalina:       "58fd557af7616ac0174875c4770f0f473f310f6a456cba5bce38173a72f4eef0"
    sha256 x86_64_linux:   "b0f3553fdd14213bc064529ad2c4e040c0ba7d807dc1e5fea6e95bf7b979b3f0"
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
