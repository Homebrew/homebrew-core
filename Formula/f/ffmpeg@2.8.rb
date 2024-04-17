class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.22.tar.xz"
  sha256 "1fbbf622806a112c5131d42b280a9e980f676ffe1c81a4e0f2ae4cb121241531"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(2\.8(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ce4b0294dbd37cc84c451100c83b35d0dbb4a4f62c3ae6b897577928c2824c62"
    sha256 arm64_ventura:  "9a6e193bd3e2c76dd1d44daa7f9da5e07e66ce364d83908e5e7fe26512545e2f"
    sha256 arm64_monterey: "878e4d8b5d2e0da0f3dc31a802e3081e9a5bccde2a71cb171490ee8f1b9a271b"
    sha256 sonoma:         "a190fb614704211a2d38ef2199c4da37c0318f5e59b40c799e105f7dbd084c50"
    sha256 ventura:        "39dc3173f263a1a52631f29a2a24c9ca99307e10ddb02317bd73b797f097dce6"
    sha256 monterey:       "7a9bf7a4e873d9693d5c14b2340382e8731acc1633a50f2f4b18b67cfb55401f"
    sha256 x86_64_linux:   "a547e14ec86a6927096e887ac5f7308cdfdd3f4e0d3341afb3367f2e86e0e82a"
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
  depends_on "sdl12-compat"
  depends_on "snappy"
  depends_on "speex"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz" # try to change to uses_from_macos after python is not a dependency

  def install
    # Work-around for build issue with Xcode 15.3
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

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
      --disable-indev=jack
      --disable-libxcb
      --disable-xlib
    ]

    args << "--enable-opencl" if OS.mac?

    # A bug in a dispatch header on 10.10, included via CoreFoundation,
    # prevents GCC from building VDA support. GCC has no problems on
    # 10.9 and earlier.
    # See: https://github.com/Homebrew/homebrew/issues/33741
    args << if ENV.compiler == :clang
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
