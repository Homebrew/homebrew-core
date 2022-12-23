class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.20.5.tar.xz"
  sha256 "b152e3cc49d014899f53c39d8a6224a44e1399b4cf76aa5f9a903fdf9793c3cc"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "68a158c5361724ddee7652ff73329a462fe2739bbb7d1ae34b17971f0e31783f"
    sha256 cellar: :any, arm64_monterey: "a1eb99674d0c4d6611c0822764e9e2cb7835c24c5aec060e4536ec2deecb90e1"
    sha256 cellar: :any, arm64_big_sur:  "ee0a769cf947704b402f9de6b301dcab7a9d9df41f52a505e3c3fa0a4e0a8e82"
    sha256 cellar: :any, ventura:        "79056f909e53becc8f909b4235e43951630bc18f0dec175e157fe828c589aa8d"
    sha256 cellar: :any, monterey:       "0b432b068dac62127f67c628acff2cf401f1a786198f13d6e9ecd0116684ea90"
    sha256 cellar: :any, big_sur:        "0fd39dc6d2e527d4735deade5e7fa6a67f589e63e889bfbe27e9aa924a661d31"
    sha256               x86_64_linux:   "5492b4ce5ea6833a284a9caabbb2dc0f6e600e5fc6268aecbba1e16537733342"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

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
