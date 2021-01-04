class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.18.2.tar.xz"
  sha256 "36969ad44c5f0756a8a90215410710d6c39713d58f6cee13d663be9774557f49"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "728f62a6289e42984082577a8d2df7e393e5c738ead2854a17008d4c8be99f7d" => :big_sur
    sha256 "f76880d9d293aabd5c645e81e2db9e6725967a80e76a980670534e718ea08f80" => :arm64_big_sur
    sha256 "7de44d954d26c3654cc12744276f07ae52783ec7b9627413acaecbeeb44492fe" => :catalina
    sha256 "4ebb724abec6a694169dea36213a5d0401d25382c985e4cde7ef3f38073c0dc0" => :mojave
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
