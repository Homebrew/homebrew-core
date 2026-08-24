class FfmpegAT5 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-5.1.10.tar.xz"
  sha256 "392306d6fc45dab0e9e0ea55381e071842e83a2fb31d320aeda40477a7766293"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  # Passing `--enable-version3` changes the license to GPL v3+.
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(5(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "00a0694e72b000d3bb48b478317c6bf2402049cb157b6000a346cfa0cd21070f"
    sha256 arm64_sequoia: "53b00d152f58da5e2af779c48d6977d22d783a99649cc9d914aec49e02ec2503"
    sha256 arm64_sonoma:  "20a9832d6d518ecfc1ed802e80650e76d1a28f379e25faca9006b9bf7e26d72e"
    sha256 sonoma:        "9b5a57cbebfa4cd6ff55e268446190918705e93845f6770d3da9d99da7890b52"
    sha256 arm64_linux:   "0eb41cb73e42cd14012f6d40f3fc038d31b1d04db58da59db650a9bc392095f0"
    sha256 x86_64_linux:  "69f171e83d45ef026328044675cb8b9fbf8fb607937ced58102c5d20c83b8449"
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
  depends_on "sdl2-compat"
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
    type :backport
  end

  # Backport support for svt-av1 4.x
  patch do
    url "https://github.com/FFmpeg/FFmpeg/commit/a5d4c398b411a00ac09d8fe3b66117222323844c.patch?full_index=1"
    sha256 "19bae44a05aa7adbdabfe7479ee2f20e6ed6ad1f4b8adee6f646edba12d47030"
    type :backport
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
