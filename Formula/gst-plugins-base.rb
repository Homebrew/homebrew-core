class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.18.4.tar.xz"
  sha256 "29e53229a84d01d722f6f6db13087231cdf6113dd85c25746b9b58c3d68e8323"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "fecdca796239e6fea130d1118aa3787795514a73de3fd14abf3bcf577249ce5f"
    sha256 arm64_big_sur:  "515d468ba628c2a1e0f6117e8c93ddaf69549a4742ea66056852fb27135e32b1"
    sha256 monterey:       "f084473c86551d9b81718d2c9ab625de397e1663507bdb1bdab593f51b59456c"
    sha256 big_sur:        "85461a70764b122fe3da3b32922129246f7a12317685dbf1d317820efd533d52"
    sha256 catalina:       "65e3329df9582b7e647bd36469301884d43ff4307efabb633bd5246c1ad77eb5"
    sha256 mojave:         "6153ce479e570753951e89d8a82de7936804d600f177f3ccafa43890ca36d27b"
    sha256 x86_64_linux:   "bfe0cef05538f4f1321bda4bc656469c92a50af6da75e814a0638d8e91aa5b86"
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
