class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.22.0.tar.xz"
  sha256 "0e48407b4905227a260213dbda84cba3812f0530fc7a75b43829102ef82810f1"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git", branch: "master"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "23c142bd81ba559fe56a97adfabee71b2ca28523cd8990bc146349a534b48c22"
    sha256 cellar: :any, arm64_monterey: "450645a9b02cda7287e555f7daa1efb458b27cf5cf3e9876dfeb05057bf8d6d1"
    sha256 cellar: :any, arm64_big_sur:  "3c70052bddc8fc42bb1974687565c9bf8dffbcc1aa6d4e9734211f45eb8e0574"
    sha256 cellar: :any, ventura:        "a198a59edf7ae7e56d282d83bac641769064f2fb2b870a4eebf4d9b23aec3284"
    sha256 cellar: :any, monterey:       "e6871e72ec94c91cd1d30ba8d5bf4fac6ba8837de1a3c604b5f336a0bb7f7b27"
    sha256 cellar: :any, big_sur:        "d1151394b763d7f288e53a0840171d5150714726582aa3e4d0f6dbc0c45f4d66"
    sha256               x86_64_linux:   "ffc41092c742044ac33e9af5b14e605128bc7fc3ae57ab79370483a3f44b95d8"
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
