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
    sha256 cellar: :any, arm64_ventura:  "b8a62a772040f6e4fc5839c58ea69bfd854af0dfe773c0ca418415f59d14a32a"
    sha256 cellar: :any, arm64_monterey: "1daca6a1f15104b6d7e4455adaa7e1f7302437c6f2984b3cdd1c663ae188c264"
    sha256 cellar: :any, arm64_big_sur:  "924463dc90fecb99b47f1aa34ddc8cf69abc9d1fbf19fc79b5c5b516f4cbf858"
    sha256 cellar: :any, ventura:        "4583e0a46b5968a7f1d72fbb6aaa34f6c7f40278de0b617d090cfa6d507857e0"
    sha256 cellar: :any, monterey:       "ca994abf313f85efd894bcc0197817dfe384c71a00bc5efdf3d6ab312d923c08"
    sha256 cellar: :any, big_sur:        "db9dd43b08529ba2cb3110f7c1af2c1a80c39c7d8638cd761a0f68665057bd6a"
    sha256               x86_64_linux:   "decfafa86cc433e8b14e2320e375252b2308d8871262b0fbbd83420990c240c4"
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
