class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.18.1.tar.xz"
  sha256 "39a717bc2613efbbba19df3cf5cacff0987471fc8281ba2c5dcdeaded79c2ed8"
  license "LGPL-2.1-or-later"
  head "https://anongit.freedesktop.org/git/gstreamer/gst-libav.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "ce24ec8a013573c32b3dc6ea87a293c357940bde754c14122791f1364f163d5b" => :catalina
    sha256 "de2f2af27d204baa1c237696a26d83e9135501d646f9725aa2d10256a9cb42a3" => :mojave
    sha256 "0a1cce814e298ee0ad6ba15e5b35f827aebdda29e3e423ca697b11d45f7718cc" => :high_sierra
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
