class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.1.tar.xz"
  sha256 "a38ec4d026efb58506a99ad5cd23d5a9793b4bf415f2c4c2e9c1bb444acd1994"
  revision 6
  head "https://github.com/FFmpeg/FFmpeg.git"

  bottle do
    rebuild 1
    sha256 "2ddcdf6d1a06694eaf262c8a06a2d919eeb3047984e77449761a9c7834b7135b" => :mojave
    sha256 "6d04eca21b46264566102aaeae2d030776f71bc75a2587c8a5b9600e7b9c711b" => :high_sierra
    sha256 "bacf852c966847ef0a54e6c4a8e5e78920f898c6e734b68be07f3f6815fa1a3d" => :sierra
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "aom"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "openjpeg"
  depends_on "opus"
  depends_on "rtmpdump"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "speex"
  depends_on "tesseract"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --enable-hardcoded-tables
      --enable-avresample
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gpl
      --enable-libaom
      --enable-libbluray
      --enable-libmp3lame
      --enable-libopus
      --enable-librubberband
      --enable-libsnappy
      --enable-libtesseract
      --enable-libtheora
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libx265
      --enable-libxvid
      --enable-lzma
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-librtmp
      --enable-libspeex
      --enable-videotoolbox
      --disable-libjack
      --disable-indev=jack
      --enable-libaom
      --enable-libsoxr
    ]

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
