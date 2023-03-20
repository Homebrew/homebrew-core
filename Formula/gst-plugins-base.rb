class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.22.0.tar.xz"
  sha256 "f53672294f3985d56355c8b1df8f6b49c8c8721106563e19f53be3507ff2229d"
  license "LGPL-2.0-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gstreamer.git", branch: "main"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "67aeb22f0e40a2752b61fef765c955f192e61f1e95fabd6fccc07b66d2adcaf4"
    sha256 arm64_monterey: "f6482c457172d930da2d2076864448d262e2aa54bf8980b4f19eb1835f568983"
    sha256 arm64_big_sur:  "7cc78006d75aa351a13bd37b248a045f61f02f17ffd776d52c84b7cf7e573d47"
    sha256 ventura:        "a9b7872ad2807aca2cf6ae39f15955df37cd16ad3a43c5393777c00b698b2130"
    sha256 monterey:       "6ea628ffd3de380e754b976279b0a01987cfb5309116124f6bd2e972cc61ac7b"
    sha256 big_sur:        "9447c4edf79e62de63cf36c23d9f219b3862771cf1e0c2f97e5020695abcf802"
    sha256 x86_64_linux:   "480df6404260fe6205219f44ed38688fa7f07da77063fcd120d661861dead2af"
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

  on_linux do
    depends_on "freeglut"
  end

  def install
    # gnome-vfs turned off due to lack of formula for it.
    args = std_meson_args + %w[
      -Dexamples=disabled
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
