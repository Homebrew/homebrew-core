class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.1.tar.xz"
  sha256 "a38ec4d026efb58506a99ad5cd23d5a9793b4bf415f2c4c2e9c1bb444acd1994"
  revision 2
  head "https://github.com/FFmpeg/FFmpeg.git"

  bottle do
    rebuild 1
    sha256 "27bc975b1126e5d12ea77df58bbe2d9c66c36859cf1708ad77480b328b8b8451" => :mojave
    sha256 "b383a94342e0e8a5a05f4f10a61ca0cf8d99c2bd48d6e3573e13053ab31c6761" => :high_sierra
    sha256 "e47af019fbefef63215b20930524896c8bf3111e46ddea62d1ab92d370d27fc2" => :sierra
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build

  depends_on "freetype"
  depends_on "frei0r"
  depends_on "lame"
  depends_on "libass"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "opus"
  depends_on "rtmpdump"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "speex"
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
      --enable-libmp3lame
      --enable-libopus
      --enable-libsnappy
      --enable-libtheora
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libx265
      --enable-libxvid
      --enable-lzma
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-librtmp
      --enable-libspeex
    ]
    args << "--enable-videotoolbox" if MacOS.version >= :mountain_lion

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
