class GstGtk < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.16.0.tar.xz"
    sha256 "654adef33380d604112f702c2927574cfc285e31307b79e584113858838bb0fd"
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "check"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gst-plugins-base"
  depends_on "gtk+3"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-alpha
      --disable-apetag
      --disable-audiofx
      --disable-audioparsers
      --disable-auparse
      --disable-autodetect
      --disable-avi
      --disable-cutter
      --disable-debugutils
      --disable-deinterlace
      --disable-dtmf
      --disable-effectv
      --disable-equalizer
      --disable-flv
      --disable-flx
      --disable-goom
      --disable-goom2k1
      --disable-icydemux
      --disable-id3demux
      --disable-imagefreeze
      --disable-interleave
      --disable-isomp4
      --disable-law
      --disable-level
      --disable-matroska
      --disable-monoscope
      --disable-multifile
      --disable-multipart
      --disable-replaygain
      --disable-rtp
      --disable-rtpmanager
      --disable-rtsp
      --disable-shapewipe
      --disable-smpte
      --disable-spectrum
      --disable-udp
      --disable-videobox
      --disable-videocrop
      --disable-videofilter
      --disable-videomixer
      --disable-wavenc
      --disable-wavparse
      --disable-y4m
      --disable-nls
      --disable-directsound
      --disable-waveform
      --disable-oss
      --disable-oss4
      --disable-osx_audio
      --disable-osx_video
      --disable-gst_v4l2
      --disable-x
      --disable-aalib
      --disable-aalibtest
      --disable-cairo
      --disable-flac
      --disable-gdk_pixbuf
      --disable-jack
      --disable-jpeg
      --disable-lame
      --disable-libcaca
      --disable-libdv
      --disable-libpng
      --disable-mpg123
      --disable-pulse
      --disable-dv1394
      --disable-qt
      --disable-shout2
      --disable-soup
      --disable-speex
      --disable-taglib
      --disable-twolame
      --disable-vpx
      --disable-wavpack
      --disable-zlib
      --disable-bz2
      --enable-gtk3
      --disable-gtk-doc
      --datarootdir=#{share}/gst-gtk
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", "--help"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin gtk")
    assert_match version.to_s, output
  end
end
