class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.22.tar.xz"
  sha256 "1fbbf622806a112c5131d42b280a9e980f676ffe1c81a4e0f2ae4cb121241531"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 8

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(2\.8(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "bae260c1a31f316dd652f4303f8432c48fc204e24d4d43991dc87b05cc60499d"
    sha256 arm64_sequoia: "4c4d7e61422afc7d4124be058dd4d9eabbcbb8c0412eb4ad5fd7a4cbbf9bcdc0"
    sha256 arm64_sonoma:  "5094bd37d69bab6ade913ff8663081a7969ce23db6d72753eba941f338c7114a"
    sha256 sonoma:        "32e4419502dac2f59cfe8c7b82506f00f152fab55c395bf0a0506ed2c464569e"
    sha256 arm64_linux:   "7ed56e8b454a70d760824309e9a2241fa3fe29e0f750c8d18aec6c28af6ba028"
    sha256 x86_64_linux:  "5b447d92a974d1a3fb96e0f0b2ac9761906de6d47d15b2f1834992b74670e44f"
  end

  keg_only :versioned_formula

  # On deprecation date, we had over 5 versions of FFmpeg and `ffmpeg@2.8` was
  # the least popular with 280 installs in 90 days. This means it no longer
  # satisfies https://docs.brew.sh/Versions#acceptable-versioned-formulae
  #
  # > No more than five versions of a formula (including the main one)
  # > will be supported at any given time, unless they are popular
  # > (e.g. have over 1000 analytics 90 days installs of usage)
  deprecate! date: "2026-01-17", because: :versioned_formula
  disable! date: "2027-01-17", because: :versioned_formula

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

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
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
