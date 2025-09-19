class FfmpegAT4 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.4.6.tar.xz"
  sha256 "2290461f467c08ab801731ed412d8e724a5511d6c33173654bd9c1d2e25d0617"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(4(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1595109a6a9bdbc696bb08cf8179123c69b3cd2b6ab8315cde92ed029dad566f"
    sha256 arm64_sequoia: "f6a1da70f31863bc297d2b6c0719c47427cee93e1a4288063de4204d731adf38"
    sha256 arm64_sonoma:  "be2f161312e0547a838b2aa161cbfdcc3c5c01e4295d2912018dce3e1c5e82e0"
    sha256 arm64_ventura: "34faf5224c373d9d68fbd7974206b7c650c3075a0e0a2d10cdb9254c8bdab42d"
    sha256 sonoma:        "dcc94072cb43bf7791a6961f747be311152d5c0c9eb25324826d198863d591b2"
    sha256 ventura:       "5929deded8985d6d8885f93cf2ab85a12a381398249c3ae004d5b066e45ceda2"
    sha256 arm64_linux:   "e98bd211efcbce53e2b23e535040abb271bbab727366a5223dedbd2e4df9ab40"
    sha256 x86_64_linux:  "cf078e54cd3122ca70af8304f8e5c5df5d648c936faf106a5f2a3aaa61f7ca78"
  end

  keg_only :versioned_formula

  depends_on "nasm" => :build
  depends_on "pkgconf" => :build

  depends_on "aom"
  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "librist"
  depends_on "libsoxr"
  depends_on "libvidstab"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "libxcb"
  depends_on "opencore-amr"
  depends_on "openjpeg"
  depends_on "opus"
  depends_on "rav1e"
  depends_on "rubberband"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "speex"
  depends_on "srt"
  depends_on "tesseract"
  depends_on "theora"
  depends_on "webp"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"
  depends_on "zeromq"
  depends_on "zimg"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libarchive"
    depends_on "libogg"
    depends_on "libsamplerate"
    depends_on "libvmaf"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxv"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-avresample
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libaom
      --enable-libbluray
      --enable-libdav1d
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librist
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
      --enable-libtesseract
      --enable-libtheora
      --enable-libvidstab
      --enable-libvorbis
      --enable-libvpx
      --enable-libwebp
      --enable-libx264
      --enable-libx265
      --enable-libxml2
      --enable-libxvid
      --enable-lzma
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libopencore-amrnb
      --enable-libopencore-amrwb
      --enable-libopenjpeg
      --enable-libspeex
      --enable-libsoxr
      --enable-libzmq
      --enable-libzimg
      --disable-libjack
      --disable-indev=jack
    ]

    # Needs corefoundation, coremedia, corevideo
    args << "--enable-videotoolbox" if OS.mac?

    # The new linker leads to duplicate symbol issue
    # https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/issues/140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.ld64_version.between?("1015.7", "1022.1")

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable?(f) && !File.directory?(f) }

    pkgshare.install "tools/python"
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_path_exists mp4out
  end
end
