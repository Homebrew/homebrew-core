class FfmpegAT4 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-4.4.3.tar.xz"
  sha256 "6c5b6c195e61534766a0b5fe16acc919170c883362612816d0a1c7f4f947006e"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(4(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f59ada15200bae0998b487377e34dbd9b97f5dc52ec6734277bccae898cc3fb2"
    sha256 arm64_monterey: "866e74fcddfe78b064e839872aa8ff9c29b8046b9d82b7613e338cf0adc58eb5"
    sha256 arm64_big_sur:  "86649a496cae264602a534c628d2cfd8d94035e0680a14e18997bdc0b86ab064"
    sha256 ventura:        "d7f86718441d476388177ccd6acf66964713963d6cd57ae882e5cb58a201658f"
    sha256 monterey:       "da78405348e33a059341e4803a13b153454e2bda2892948fe3fd0e94a0974361"
    sha256 big_sur:        "04eb4a744cb8374098ea628536aeec08dc1d04544db6cb3c65dde549dab1266c"
    sha256 x86_64_linux:   "fb266a9fb41e781dfe270dce34ca9de12ae2c5956b9f93b43e7c14c0df630b66"
  end

  keg_only :versioned_formula

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
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
  depends_on "libvmaf"
  depends_on "libvorbis"
  depends_on "libvpx"
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

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
  end

  fails_with gcc: "5"

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
      --enable-libvmaf
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

    # Replace hardcoded default VMAF model path
    %w[doc/filters.texi libavfilter/vf_libvmaf.c].each do |f|
      inreplace f, "/usr/local/share/model", HOMEBREW_PREFIX/"share/libvmaf/model"
      # Since libvmaf v2.0.0, `.pkl` model files have been deprecated in favor of `.json` model files.
      inreplace f, "vmaf_v0.6.1.pkl", "vmaf_v0.6.1.json"
    end

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
    assert_predicate mp4out, :exist?
  end
end
