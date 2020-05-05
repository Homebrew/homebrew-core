class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.16.tar.xz"
  sha256 "6b895902f1ec0d738af40f514dfeac6caba143aa2d0a17af22397c2fc4ebc092"
  revision 1

  bottle do
    sha256 "858c27ee5f7220c59cc2bd4f6edb78e18b7b9e4320e252b51f307a5663e9ce7b" => :catalina
    sha256 "55a0639513fc5e876b8d65b54725a6a79d69d6a9b56f7b280d8a4082c0643ffe" => :mojave
    sha256 "eacd1a6566db61be9d48b245cefc0f3784cc12e8b5bbf08941918c0d5425f7e1" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "lame"
  depends_on "libass"
  depends_on "libvo-aacenc"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "opus"
  depends_on "rtmpdump"
  depends_on "sdl"
  depends_on "snappy"
  depends_on "speex"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"

  def install
    # Fixes "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"
      inreplace %w[libavdevice/v4l2.c libavutil/time.c], "HAVE_CLOCK_GETTIME",
                                                         "UNDEFINED_GIBBERISH"
    end

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-gpl
      --enable-version3
      --enable-hardcoded-tables
      --enable-avresample
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-libmp3lame
      --enable-libopus
      --enable-libsnappy
      --enable-libtheora
      --enable-libvo-aacenc
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libx265
      --enable-libxvid
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-librtmp
      --enable-libspeex
      --enable-opencl
      --disable-indev=jack
    ]

    # A bug in a dispatch header on 10.10, included via CoreFoundation,
    # prevents GCC from building VDA support. GCC has no problems on
    # 10.9 and earlier.
    # See: https://github.com/Homebrew/homebrew/issues/33741
    args << if MacOS.version < :yosemite || ENV.compiler == :clang
      "--enable-vda"
    else
      "--disable-vda"
    end

    system "./configure", *args

    inreplace "config.mak" do |s|
      shflags = s.get_make_var "SHFLAGS"
      s.change_make_var! "SHFLAGS", shflags if shflags.gsub!(" -Wl,-read_only_relocs,suppress", "")
    end

    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-y", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
