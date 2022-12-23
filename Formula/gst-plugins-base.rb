class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.20.5.tar.xz"
  sha256 "11f911ef65f3095d7cf698a1ad1fc5242ac3ad6c9270465fb5c9e7f4f9c19b35"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-base/"
    regex(/href=.*?gst-plugins-base[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "fda39c4890fdaa8fefdd416376c3fdb475f629064331fa7c379c2767cbd9d920"
    sha256 arm64_monterey: "1f36ba1d263bef1e05b82c8f897e02f74211f06a75f009f7607f5d8f97de532c"
    sha256 arm64_big_sur:  "81301c6d1f9aeb0e6b5bea26496999afdc1991ae4a1d05c00d60c320ab98bf1c"
    sha256 ventura:        "277c06b06f8b6e2b208af56ba047a6a85f927d33cef4a38ecaf5097d5ee73d2a"
    sha256 monterey:       "abd3b6da80e62a9ea1c350f5701b2a815b8d3382b2b0405b93f90bd6ff60e80d"
    sha256 big_sur:        "d0e1047302c82742efba9c87db51e4d6bcae140da534299224796c0b870b0f4c"
    sha256 x86_64_linux:   "fe919b136c41d2fbf73296360984d9ee21da16583fcbadd5ea66a24e7b083f12"
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
