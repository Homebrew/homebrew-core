class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.1.1.tar.xz"
  sha256 "373749824dfd334d84e55dff406729edfd1606575ee44dd485d97d45ea4d2d86"
  head "https://github.com/FFmpeg/FFmpeg.git"

  bottle do
    sha256 "468153bac4b90b445fa5c6adfb70ec3213ebc0f63c7a97a6b2a1649d9c32a786" => :mojave
    sha256 "152657e2793e9105dacf8badf787f826734b6407741b1e764d91502837c84647" => :high_sierra
    sha256 "c495601c6e1c14b00d025218a9228706723b3f13f371ec98a7a00eb72066706f" => :sierra
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "aom"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
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
      --enable-gnutls
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
