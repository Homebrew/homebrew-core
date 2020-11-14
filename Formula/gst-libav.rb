class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.18.1.tar.xz"
  sha256 "39a717bc2613efbbba19df3cf5cacff0987471fc8281ba2c5dcdeaded79c2ed8"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "4fbab8e339a32dff4c432113f6e84608702f384c5c9f22eb74140fd3c3c0205b" => :catalina
    sha256 "3e97b626bbdd6c767a8c56e8669a4881e7506f76092776baf1f0f6a830f3b562" => :mojave
    sha256 "0d0dacf7c90b1f46e79604b596032ae642c8404f7ee7bfa70df2d6cba2ef2a62" => :high_sierra
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
