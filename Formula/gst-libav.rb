class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.20.1.tar.xz"
  sha256 "91a71fb633b75e1bd52e22a457845cb0ba563a2972ba5954ec88448f443a9fc7"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "eed1456fdb149b43fbe33bf073b6d25e8c5471b2c1295e91b92cafa6443b0c1d"
    sha256 cellar: :any, arm64_big_sur:  "85e8073b40bfdc594ce8a99a1c1f769877e4e96cba19d22af3eece39f847ac69"
    sha256 cellar: :any, monterey:       "16bc393eaf8bb4fed8d7c13a6545bf44656e5b4b59e80c2c7dde538ad88fa0a7"
    sha256 cellar: :any, big_sur:        "07401844ad201ae68b992ff81d46962abd8782e6194d45c1562763dd845646b4"
    sha256 cellar: :any, catalina:       "84cd71eac79c4f03b70e092276a8326d2287633b11a2872b4a0a2ec35d193357"
    sha256               x86_64_linux:   "596d5ee1dffe0c623c8dc0773dfa884470ae51f50688712ad6796d59557bedaa"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
