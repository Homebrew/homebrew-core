class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.21.tar.xz"
  sha256 "e5d956c19bff2aa5bdd60744509c9d8eb01330713d52674a7f650d54b570c82d"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(2\.8(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "89be05eeb2d6d6b6a6b2d21f0d158f9dd31c6f0014ab4371f39013dfe600fecc"
    sha256 arm64_ventura:  "39ab9275cf8e96084bf71186064c3b44a266bb9738bfbed6e276182acbc62c9e"
    sha256 arm64_monterey: "e2933796de987f8b85ccf3a8ad0cfc762866a5d51cea54fd0202d74c64736050"
    sha256 arm64_big_sur:  "be1a0c4ce83319cb11a6df578ac665968e8ce79696229bcb3d9624cdf1c1dca2"
    sha256 sonoma:         "46bbc62d6e8fc5c801dcefe7d81322fd6b69b8d728dcf9048c107deb626f09d5"
    sha256 ventura:        "1de0658a8355e4879bed836d15f58e30832b42ed3b0b968c810874d5408d5eb1"
    sha256 monterey:       "7d9ed87744201a90e1c40432484584b5485e359002f982796e07425dfe85a8e3"
    sha256 big_sur:        "b68fb395e1651b58d0f5edd40f49bbaf7a9a02b2f5aa1466dd62a991ea967676"
    sha256 x86_64_linux:   "c82117dfcbefff995ca06b5f033ffa37f7ba0b1e22030083a9e440c536e8c86b"
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
