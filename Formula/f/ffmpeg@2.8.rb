class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.22.tar.xz"
  sha256 "1fbbf622806a112c5131d42b280a9e980f676ffe1c81a4e0f2ae4cb121241531"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(2\.8(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "13a13bc5e5925cc58c9537f0855fe2850c337af0f6399f1ae9fdf51fe143a383"
    sha256 arm64_sonoma:  "9172b677b6d999bb32f9f71bc02707feadd7506dd89faf34f15ad815278acf3b"
    sha256 arm64_ventura: "e65a35476a811374581f95b18feb2e245963064b8fc5e7c05d13e9e572673c87"
    sha256 sonoma:        "18b83d9f3571338fba54ed29c94c0179067179104c8f08279e3df88d5f20618b"
    sha256 ventura:       "b340b32bce5da478d359568816637da29a3efcf514cf07084ea9a921e3aec274"
    sha256 x86_64_linux:  "5dada8be047205bd21c2f1d7b56e78595e42c8f89b3a6a6446645c26e0da1d07"
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
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-y", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_path_exists mp4out
  end
end
