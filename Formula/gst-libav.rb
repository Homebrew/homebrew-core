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
    sha256 cellar: :any, arm64_monterey: "ab038ddcfcf943f1eab2fc2de0a2c705002b293b41b5ff00eb9df06f18cf1135"
    sha256 cellar: :any, arm64_big_sur:  "bdfb83385a80024cc625d7fb2e4ffd67f35cd7d53028e365beba5e97aed6591b"
    sha256 cellar: :any, monterey:       "abaae88c7295e198692d1741da2f77360acce8300de2c3f8ba694c2209d8b48f"
    sha256 cellar: :any, big_sur:        "29a5114a5f705beeac7a410d67a48ab884b3bc059335c55670a75a9f6969ce4e"
    sha256 cellar: :any, catalina:       "bfbb7efd56f750b5f03d4b020751fba6d6d544c6840b6a0feaa06b69d1e474b0"
    sha256               x86_64_linux:   "450743067dc7342cbdc91a2302b2d0c7822facd07da0e758e2a499cbc1d17050"
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
