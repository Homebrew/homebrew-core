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
    sha256 arm64_monterey: "2491152f4f84cb9b5229c84e75a5b21a72ff9d410eac12ed1003e0526efb9ab2"
    sha256 arm64_big_sur:  "ce62108d6e9b1508b8cc388bbabf50eb176a9c687a7a9c7f35d935d8ea770b75"
    sha256 monterey:       "6270c08e52101f3df5734bce8c41edae27a40f19316e8e0f2f1039da4e981f0b"
    sha256 big_sur:        "7b9fa237ee26eefc873430fb1a1e742eb489a75a83cc2ed66e392fa575616bca"
    sha256 catalina:       "22980d6f57e18ecbcfb567ef018ecaf648cbf26cc51b0ca76af2d08277dc388e"
    sha256 x86_64_linux:   "65ed258e4436ad5d9b6496e0a4d2f4989ad696204d6d9297a7d85720e3bc1ea8"
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
