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
    sha256 arm64_ventura:  "ec71766211d31b8300b2475b1f0fdc8b01a144dc7e2f8f81dc01f07b7db978a3"
    sha256 arm64_monterey: "6b26c8d07ee85b3dfb2208f1fe17bcfc552ef34c9baefb6bb06f7006df55dd9b"
    sha256 arm64_big_sur:  "0147c9958bcc7b285d2064690e07e1db914bc09a38b839fb4e8f1b72cf63b367"
    sha256 ventura:        "2e13d8e8f9505338cce3deb091170dd497f9b42a4df900620d364dcbdb086c87"
    sha256 monterey:       "2935a2b7adc86391f345b18edc1ae524f3891e7767c8eefc2f5267ee584c431e"
    sha256 big_sur:        "6fa559b478d2dff3294fa4e6d922ac3d9d2f68ed0b9f0c4f4c98520602fe3afd"
    sha256 x86_64_linux:   "1a25f75c42202eb653dcecc32c765ac238303ea1387fadc98e0d0e19a2f0a432"
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
