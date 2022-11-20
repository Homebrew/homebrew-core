class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.21.tar.xz"
  sha256 "e5d956c19bff2aa5bdd60744509c9d8eb01330713d52674a7f650d54b570c82d"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(2\.8(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "631da5126dffc9e3a5d6b3566600043d24db1d0ac1018ed8186f640140a06a57"
    sha256 arm64_monterey: "d245628d182a509c300fd92a75dfbabf768233d23a58d2b50319e193b099ddb7"
    sha256 arm64_big_sur:  "47a272fe59671de09bebb4531127d0490ad6691db2577949208b3767943e9283"
    sha256 ventura:        "e770a4067a200bffa6723f49788d4e50a0956d0e26200d864bc3901d4e826a6b"
    sha256 monterey:       "bec2b52eef70f54ac9de2b885d14d5e68e16b6e79beeb78ea7fdffeddbe2bbc1"
    sha256 big_sur:        "2fa1b3d92f4c1c7712213c39b693867498c13fe9b3e771932268bd3a78dbe992"
    sha256 catalina:       "b09b941d608db1dcd63f846ccb9f6076dc7242242394ce1d915d4ce8fda26a3f"
    sha256 x86_64_linux:   "2488d7dc0593af8df7660f49a01edb4d432228ad8211da187fee43a7670d4404"
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
