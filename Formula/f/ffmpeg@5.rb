class FfmpegAT5 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-5.1.8.tar.xz"
  sha256 "56d4daf10c17330a45c8fe11bc260997677ca2432d3d5951dbeb5515c26028cb"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(5(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "25940f9804b20a917bacee01f7de60822a471c13f2517ae39290cbd3e274817c"
    sha256 arm64_sequoia: "1aca1deabd707924b66423c6dc13dc188d80ccf8ae9c769d04d552633b75afec"
    sha256 arm64_sonoma:  "74e861cfe3e34378f00831790cc7c7595136cff7795fb67715d007303466ced0"
    sha256 sonoma:        "5c3273cc532bfea336151a84474eb6fdb8ca5707114689cac10712b226673e2b"
    sha256 arm64_linux:   "ec24e53289159d9b67a6107571242a19a77926be1d84968bce4665e132bfa2c8"
    sha256 x86_64_linux:  "9e6cfd2b7a048ddd255994a16eeacc0918a54b2f07ba5c35a9e3bd0cf10c8283"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "aom"
  depends_on "aribb24"
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
  depends_on "libx11"
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
  depends_on "svt-av1"
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

  on_macos do
    depends_on "libarchive"
    depends_on "libogg"
    depends_on "libsamplerate"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxext"
    depends_on "libxv"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # Backport support for svt-av1 3.x
  patch do
    url "https://github.com/FFmpeg/FFmpeg/commit/d1ed5c06e3edc5f2b5f3664c80121fa55b0baa95.patch?full_index=1"
    sha256 "0eb23ab90c0e5904590731dd3b81c86a4127785bc2b367267d77723990fb94a2"
  end

  # Backport support for svt-av1 4.x
  patch do
    url "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/a5d4c398b411a00ac09d8fe3b66117222323844c"
    sha256 "1dbbc1a4cf9834b3902236abc27fefe982da03a14bcaa89fb90c7c8bd10a1664"
  end

  def install
    # The new linker leads to duplicate symbol issue https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/issues/140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.ld64_version.between?("1015.7", "1022.1")

    args = %W[
      --prefix=#{prefix}
      --datadir=#{share}/ffmpeg
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libaom
      --enable-libaribb24
      --enable-libbluray
      --enable-libdav1d
      --enable-libmp3lame
      --enable-libopus
      --enable-librav1e
      --enable-librist
      --enable-librubberband
      --enable-libsnappy
      --enable-libsrt
      --enable-libsvtav1
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
    args << "--enable-neon" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath/"tools").children.select { |f| f.file? && f.executable? }
    (share/"ffmpeg").install buildpath/"tools/python"
  end

  test do
    # Create a 5 second test MP4
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4out
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("#{bin}/ffprobe -hide_banner #{mp4out} 2>&1"))

    # Re-encode it in HEVC/Matroska
    mkvout = testpath/"video.mkv"
    system bin/"ffmpeg", "-i", mp4out, "-c:v", "hevc", mkvout
    assert_match(/Duration: 00:00:05\.00,.*Video: hevc/m, shell_output("#{bin}/ffprobe -hide_banner #{mkvout} 2>&1"))
  end
end
