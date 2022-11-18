class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.20.3.tar.xz"
  sha256 "3fedd10560fcdfaa1b6462cbf79a38c4e7b57d7f390359393fc0cef6dbf27dfe"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "7f05ebcf2ab83cd8bb35f1c5f8eb6e0d34d209a1ffb1ecd133c214335f38d9fe"
    sha256 cellar: :any, arm64_monterey: "4065537d800b19238c38b4b1d42cb92f194468049db105d733f8f17a742e2d9a"
    sha256 cellar: :any, arm64_big_sur:  "340789fce634714aaae27165addaa43bb40f53ab69238ced86d7ded7782ae1e1"
    sha256 cellar: :any, ventura:        "7e0d503ad7290317384f862ad19800c4c7743f77ccd28c9318156ba2193cab65"
    sha256 cellar: :any, monterey:       "94daf9f1df921d2a72c085ba5ca3c5df532320d692d3b8d422f687396ee08b44"
    sha256 cellar: :any, big_sur:        "2da4802458d0198c41315b6144d51ed20f8bd44f39ad1577388d6f7cd9b80ae3"
    sha256 cellar: :any, catalina:       "47bec12928594e7835d77c69614069190d5756ebcf77b728eb5041b27533b7fd"
    sha256               x86_64_linux:   "be06fbd85729712f0f21006039a5a42b3ecac27422860f0baa0025ac11312923"
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
