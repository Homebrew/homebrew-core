class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.0.tar.xz"
  sha256 "2d119c15ab8c9e79f8cd3c6bf582ff7a050b28ccae52ab4865e1a1464991659c"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7d2790a1aba560658c50d64d490a0ddfef4800b99f16f0c5ebd5efbd34204c3f"
    sha256 arm64_big_sur:  "3cae4fe6bc10778b7b42eee8c9f31012e9e035d1e332ec5e430d732aa07d15b3"
    sha256 monterey:       "d0363016d67dbdab5ca609ff5007b6bc9dd99ec792e088f95c6e42273e50156e"
    sha256 big_sur:        "2ef811d155295ffc30b54d9e7da5fb2910d233044119bbd9aaa85ca182e3f168"
    sha256 catalina:       "b94a12c0b0b3405130fa19439b2b1e956de4a41ce595aa15229157479880e314"
    sha256 x86_64_linux:   "1a32f18f3c3a471602573567fa3ad6de99e7b5927c0ff555e92ddd42261616c0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "flac"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libpng"
  depends_on "libshout"
  depends_on "libsoup"
  depends_on "libvpx"
  depends_on "orc"
  depends_on "speex"
  depends_on "taglib"

  def install
    args = std_meson_args + %w[
      -Dgoom=disabled
      -Dximagesrc=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end
