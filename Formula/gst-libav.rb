class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.18.5.tar.xz"
  sha256 "822e008a910e9dd13aedbdd8dc63fedef4040c0ee2e927bab3112e9de693a548"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "e8966bbb5d208f222af893b8b3a9342c9e51801944a3aafdde8a4564ae6ddec3"
    sha256 cellar: :any, arm64_big_sur:  "91b97f75dfec46ff4a5af1039d070c32ccd1935bb1a391eff25fe09b3c8d47cd"
    sha256 cellar: :any, monterey:       "ff617de0b10f0922ad9cd298d9adcb6afef8001c6a1a60c9141c3d29f95e7394"
    sha256 cellar: :any, big_sur:        "a3d8a0b77267c24a251f55093d40e2c63fed1af4e35f28e1c4a5d57f126ff630"
    sha256 cellar: :any, catalina:       "441579ff37ed24b7b608afa7c004770d9a9adea55fa5097f5e05a5023b30276b"
    sha256               x86_64_linux:   "6951f2ec1007973263e830baa836127128f3db914cacdf651a966d054da86fab"
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
