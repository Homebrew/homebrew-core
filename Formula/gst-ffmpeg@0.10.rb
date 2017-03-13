class GstFfmpegAT010 < Formula
  desc "GStreamer plugins for FFmpeg"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2"
  sha256 "76fca05b08e00134e3cb92fa347507f42cbd48ddb08ed3343a912def187fbb62"

  bottle do
    sha256 "1466479f0be48152b9d54b97b456b194c3365c59245afdfcc60c8a1686a14cae" => :sierra
    sha256 "bfd5b6aba68dd3a6c7e0f84d8ba4917e680d59feaf0b4265382b025d3d08e203" => :el_capitan
    sha256 "fb5d70d4d15e25894f664775c25856eb086e5f5e7c64ac9625f83bb559467787" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base@0.10"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-ffmpeg-extra-configure=--cc=#{ENV.cc}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer@0.10"].opt_bin}/gst-inspect-0.10", "ffmpeg"
  end
end
