class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.22.tar.xz"
  sha256 "1fbbf622806a112c5131d42b280a9e980f676ffe1c81a4e0f2ae4cb121241531"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 7

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(2\.8(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "7283cae85b5f5e67c2a651dc5f8b91128033c6b7328361adbb951e15e1f691b6"
    sha256 arm64_sequoia: "66758ba4e8df1a54b6b14c165eaec57332e1de2afae5c2296bdfd1aa94d4b507"
    sha256 arm64_sonoma:  "35060e5c989c22c0a9eef15ede9422aed7f98bb86a7acf2647f9a164fc79ac7e"
    sha256 arm64_ventura: "48b23738acea1da8e3ae59ab7ad6e9f49e4a6baa06804723a8d0729c7fc0aac2"
    sha256 sonoma:        "b5cfb6fa778c6ece95a45b4ca2318b35ea3fc8413c9e641e418f11a3dea6bef4"
    sha256 ventura:       "d32a745adb90ee398b93e7b21034b0fb8685f80c5cb2056e9c0679ad6d51a8c4"
    sha256 arm64_linux:   "acee2bb1614681484dccfd58d649a5bcdc774efc402b45d1bf108ee0183bb246"
    sha256 x86_64_linux:  "f2ba2aa6fed3859f1a03433ba43af98e31c334c04b2f581e1fc71b39471bb5d3"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "lame"
  depends_on "libass"
  depends_on "libogg"
  depends_on "libvo-aacenc"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opencore-amr"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "rtmpdump"
  depends_on "sdl12-compat"
  depends_on "snappy"
  depends_on "speex"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    args = %W[
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
      --enable-vda
      --disable-indev=jack
      --disable-libxcb
      --disable-xlib
    ]

    args << "--enable-opencl" if OS.mac?

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-dependency-tracking"] }

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
    # Create a 5 second test MP4
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4out
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("#{bin}/ffprobe -hide_banner #{mp4out} 2>&1"))

    # Re-encode it in WMV2/Matroska (HEVC support is still experimental)
    mkvout = testpath/"video.mkv"
    system bin/"ffmpeg", "-i", mp4out, "-c:v", "wmv2", mkvout
    assert_match(/Duration: 00:00:05\.00,.*Video: wmv2/m, shell_output("#{bin}/ffprobe -hide_banner #{mkvout} 2>&1"))
  end
end
