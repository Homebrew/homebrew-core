class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.20.0.tar.xz"
  sha256 "5eee5ed8d5082a31b500448e41535c722ee30cd5f8224f32982bbaba2eedef17"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "6253f9ed006717fe7a6b8fec8e6de6ef497c8666aebd87f50401c78a311c06e0"
    sha256 cellar: :any, arm64_big_sur:  "bdb77e85c054ed188a3d95a7321d56d37a49499d4390284f0635a947076db6d8"
    sha256 cellar: :any, monterey:       "9a230d412e975293fcb7eee4b6d605bb7c8810a60540320e3e9358245b44f71e"
    sha256 cellar: :any, big_sur:        "787c106c634eff084b5ce43bea81a1a9a46d18e49d35ce0fdf15619bc9e9f5e9"
    sha256 cellar: :any, catalina:       "921f18aa2f2362a53bac5f0bd24c442d4c80f3cae44f8904420bd39f80a2d3a4"
    sha256               x86_64_linux:   "04184b4dc6cbde343f8c711eedab933088656d988ea017d46894a085b42eeaea"
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
