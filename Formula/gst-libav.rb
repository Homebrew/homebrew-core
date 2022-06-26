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
    sha256 cellar: :any, arm64_monterey: "fc2fb6970dcc2e153b11d6cd53bbb61216aeb19398de18727ca75ecae450313b"
    sha256 cellar: :any, arm64_big_sur:  "99c1537bd90d255df9e4e92a90037b24a57beeb51ab44daf590dfe3a45a1b801"
    sha256 cellar: :any, monterey:       "d09097cb0f504f0e6da37f125078bc171a1923de817261f16fd3ca086f3b557c"
    sha256 cellar: :any, big_sur:        "a016cd9ef794ed2c9281c1e30f8052a59d47d21641bd083721b0cfa88bbf1db6"
    sha256 cellar: :any, catalina:       "acf202daebcfd054d1f226797c562ec8dcb610b9e5794a1548df4cd4afa89357"
    sha256               x86_64_linux:   "4b36f679caf58d93cd3434c7c517809ac57a3353571c2ee2e436d83bb76ef3d8"
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
