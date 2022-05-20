class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.20.2.tar.xz"
  sha256 "b5c531dd8413bf771c79dab66b8e389f20b3991f745115133f0fa0b8e32809f9"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a5bb77adf456fec4dd529555e263a7b0e5f0dc5860dadd6366b873305682501d"
    sha256 cellar: :any, arm64_big_sur:  "9503010e35927ef7476d4728ee362a32ea857770fc941a4acb37b075077c0757"
    sha256 cellar: :any, monterey:       "288259c50e152900e65c1993fd17cf616f48990363723b803745a8e003b51965"
    sha256 cellar: :any, big_sur:        "ffe3d26893c4c78ad95564d12b637163a2ae1f289e6a2d141a5ce990934a5e05"
    sha256 cellar: :any, catalina:       "ee1ffb5874e445f8a7254f943f28656d42723f0199b96d0e2986f209a63abda6"
    sha256               x86_64_linux:   "efee0c9eed63630267f5bb6d8ab1846a2b90c7eed7f94ba4c4fc8897b1a4c413"
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
