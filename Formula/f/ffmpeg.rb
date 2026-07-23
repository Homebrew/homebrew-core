class Ffmpeg < Formula
  desc "Play, record, convert, and stream select audio and video codecs"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-8.1.2.tar.xz"
  sha256 "464beb5e7bf0c311e68b45ae2f04e9cc2af88851abb4082231742a74d97b524c"
  # None of these parts are used by default, you have to explicitly pass `--enable-gpl`
  # to configure to activate them. In this case, FFmpeg's license changes to GPL v2+.
  # Passing `--enable-version3` changes the license to GPL v3+.
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 2
  head "https://github.com/FFmpeg/FFmpeg.git", branch: "master"

  livecheck do
    url "https://ffmpeg.org/download.html"
    regex(/href=.*?ffmpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "90fde7486968511145ad359f060eb19adf4e4fa26184e60731dbcff3e4b0243b"
    sha256 arm64_sequoia: "3b1dab25100b79de074463b6b10be1266ed0d5f6eb6409fa53707f49e24bb2a7"
    sha256 arm64_sonoma:  "38adbd173fdb77cc6a24a44722daa1f42f1775bf5f6c09a679fefdeee9749a9f"
    sha256 sonoma:        "fcc13fae2031e5adaa193bc1accb03e8127b9503d41ac29c07e3758e7a88ba88"
    sha256 arm64_linux:   "947634a5bfc9d2528e49ca232bba628ac4feedf8103d54e1970a76fa6c609c8a"
    sha256 x86_64_linux:  "0604736f61e5760bbeb51a161d8070d9d7733ff437d34d19b5a15f14ef597a11"
  end

  depends_on "pkgconf" => :build

  # Only add dependencies required for dependents in homebrew-core
  # or INCREDIBLY widely used and light codecs in the current year (2026).
  # Add other dependencies to ffmpeg-full formula.
  # We should expect to remove e.g. x264 eventually (>=2027) when usage of it is
  # negligible and has all moved to e.g. x265 instead.
  depends_on "dav1d"
  depends_on "lame"
  depends_on "libvmaf" # dependent: ab-av1
  depends_on "libvpx"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "sdl2-compat"
  depends_on "svt-av1"
  depends_on "x264"
  depends_on "x265"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxcb"
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  deny_network_access!

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
      --enable-libvmaf
      --enable-libvpx
      --enable-libx265
      --enable-openssl
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
