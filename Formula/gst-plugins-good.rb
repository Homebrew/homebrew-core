class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.20.1.tar.xz"
  sha256 "3c66876f821d507bcdbebffb08b4f31a322727d6753f65a0f02c905ecb7084aa"
  license "LGPL-2.0-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/"
    regex(/href=.*?gst-plugins-good[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ccfd7c8421f6cbafa42f8fce97f2deec94689d66715bd51a7ecf06e72ad1e2b9"
    sha256 arm64_big_sur:  "274e98ed15c58d81cd205f012af1e36b4b575249fe6165176edd2559b0aa0cbf"
    sha256 monterey:       "90a7647330792cf0cfadfdffa2e12721177ace0458938b474bc7a2f1bc9c39e6"
    sha256 big_sur:        "1e1c4a365547f757761aadcbf3e98bcfaaf6a9f6929b43dc8f1ba2d7ef6c74e5"
    sha256 catalina:       "e339f633fc7f18ebaaaf8244daafd9d3ff4679137d2ebff1be8223da3438a949"
    sha256 x86_64_linux:   "a3c23ad39170d01c6beff7f0aa029c586f95b84f08af60a151cc7e1933368401"
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
