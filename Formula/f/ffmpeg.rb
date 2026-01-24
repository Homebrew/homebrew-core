class Ffmpeg < Formula
  desc "Play, record, convert, and stream select audio and video codecs"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-8.0.1.tar.xz"
  sha256 "05ee0b03119b45c0bdb4df654b96802e909e0a752f72e4fe3794f487229e5a41"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "78852208a7d97374d3634476e0457b28434e05f12ce8e1c7e9245786a0414f5f"
    sha256 arm64_sequoia: "9c0dba9d939066bec644acec9719b63de77ff9b4d7548bfa9204bd148e53634d"
    sha256 arm64_sonoma:  "4445dedfd8c908c7a50777d1067677631c98af46c24ed333aec8b096ed0b3e27"
    sha256 sonoma:        "d49e0af60ab4c7cf007c406532b6c764040f2e7a10c09704741eb6ebf2ae4499"
    sha256 arm64_linux:   "48b15934d257788e38a4acd891d5e29f19d7ec48bfea2e44cbabfa02bc417140"
    sha256 x86_64_linux:  "cc55f95b64376291b1c947e144b63feaedaacf075b6c33993221f5427c35456a"
  end

  depends_on "pkgconf" => :build

  # Only add dependencies required for dependents in homebrew-core
  # or INCREDIBLY widely used and light codecs in the current year (2026).
  # Add other dependencies to ffmpeg-full formula or consider making
  # formulae dependent on ffmpeg-full.
  # We should expect to remove e.g. x264 eventually (>=2027) when usage of it is
  # negligible and has all moved to e.g. x265 instead.
  depends_on "dav1d"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "sdl2"
  depends_on "svt-av1"
  depends_on "x264"
  depends_on "x265"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxcb"
    depends_on "xz"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # Fix for QtWebEngine, do not remove
  # https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=270209
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/ffmpeg/-/raw/5670ccd86d3b816f49ebc18cab878125eca2f81f/add-av_stream_get_first_dts-for-chromium.patch"
    sha256 "57e26caced5a1382cb639235f9555fc50e45e7bf8333f7c9ae3d49b3241d3f77"
  end

  def install
    # The new linker leads to duplicate symbol issue https://github.com/homebrew-ffmpeg/homebrew-ffmpeg/issues/140
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.ld64_version.between?("1015.7", "1022.1")

    # Fine adding any new options that don't add dependencies to the formula.
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gpl
      --enable-libsvtav1
      --enable-libopus
      --enable-libx264
      --enable-libmp3lame
      --enable-libdav1d
      --enable-libvpx
      --enable-libx265
    ]

    # Needs corefoundation, coremedia, corevideo
    args += %w[--enable-videotoolbox --enable-audiotoolbox] if OS.mac?
    args << "--enable-neon" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install (buildpath/"tools").children.select { |f| f.file? && f.executable? }
    pkgshare.install buildpath/"tools/python"
  end

  def caveats
    <<~EOS
      ffmpeg-full includes additional tools and libraries that are not included in the regular ffmpeg formula.
    EOS
  end

  test do
    # Create a 5 second test MP4
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4out
    assert_path_exists mp4out, "Failed to create video.mp4!"
  end
end
