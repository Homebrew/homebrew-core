class FfmpegAT5 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-5.1.3.tar.xz"
  sha256 "1b113593ff907293be7aed95acdda5e785dd73616d7d4ec90a0f6adbc5a0312e"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(5(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "9c2f2fd629fc3253f6f63509f1f30ba18ed2901cff2b7151d3b8f45b6c8a3523"
    sha256 arm64_ventura:  "d35bb65a3507dea5b31ab8f5cfd8986c033936677b4ed5866dafd448cc9baefd"
    sha256 arm64_monterey: "e983392a535c5f0d8c0864095991eadfec9ee253108fea379e501b2890731c43"
    sha256 sonoma:         "7ee58d604e6f8b689480cb57d40daf66c4af2bf71723641f8b29e6d8c4f0b984"
    sha256 ventura:        "80542a31d0037553279f66b7bad42c0503d5d3513520227f4194c7e06297fe20"
    sha256 monterey:       "dadd70293274942a49d1b6821d9ac12ea97ee61380443bc989723d07b28a255d"
    sha256 x86_64_linux:   "fd60f1b7d5db9a6bd73a5ce698c53e51f716aaba6d4498b299949c1ede20cfd1"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  fails_with gcc: "5"

  # Two upstream patches, fixing compilation with recent svt-av1 versions
  # Remove in next version
  patch do
    url "https://git.ffmpeg.org/gitweb/ffmpeg.git/commitdiff_plain/bea695d54372b66a6b9b136982fc92adb63e4745?hp=33ed503e590c252ac5e191503ff45e67dc34c214"
    sha256 "76b1916d710e01b79e20342de7fb0aa5b32bfcdc903d16bd3c1eafa10a555d60"
  end

  patch do
    url "https://git.ffmpeg.org/gitweb/ffmpeg.git/commitdiff_plain/3344d47a88506aba060b5fd2a214cf7785b11483?hp=bea695d54372b66a6b9b136982fc92adb63e4745"
    sha256 "1d46c3ba395710ba8ba440fa1e6a176dd063a74539d67365389cba6d015abaf3"
  end

  # Fix for binutils on Linux, remove on next release
  # https://www.linuxquestions.org/questions/slackware-14/regression-on-current-with-ffmpeg-4175727691/
  patch do
    url "https://github.com/FFmpeg/FFmpeg/commit/effadce6c756247ea8bae32dc13bb3e6f464f0eb.patch?full_index=1"
    sha256 "9800c708313da78d537b61cfb750762bb8ad006ca9335b1724dbbca5669f5b24"
  end

  def install
    # The new linker leads to duplicate symbol issue https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/issues/140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

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
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
