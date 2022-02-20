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
    sha256 arm64_monterey: "b9a4c700974a3dc9fa4e537594fabd6c9295420bf2bde8749084c397bcce51b0"
    sha256 arm64_big_sur:  "23c5545d7dbb05726bef1fc711bffe95c5a337eacb6053dc141fa08523faed53"
    sha256 monterey:       "28e2bd546fecb0a2e90f632e71d55c67108c88d3324f1db67a99002ea593f6a0"
    sha256 big_sur:        "34ac73b746d4fc3c962e253fe71ec3a35a3dbed2f20342bd22955aa492a53562"
    sha256 catalina:       "72ba1c6c4e161443ef3b7913fe5ad6f733d818aef27de007645eb2b6195864df"
    sha256 x86_64_linux:   "def92a5fff0a77ba3c384bc78cec86756342005a27242fb07e689f6b92440602"
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
