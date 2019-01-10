class FfmpegAT28 < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-2.8.15.tar.bz2"
  sha256 "35647f6c1f6d4a1719bc20b76bf4c26e4ccd665f46b5676c0e91c5a04622ee21"
  revision 2

  bottle do
    rebuild 1
    sha256 "eeafc82f573e2478f80982dd696e1de6b3e0d6efdb8c3e922833582f5095b58c" => :mojave
    sha256 "864f2b52d3e9139140540513655650647e35d4436b7f55fc98fbfa56957f208f" => :high_sierra
    sha256 "79a95fbeac7108dcaa79884b4e9faa59dd5a662e1d9c3aa1a2028bd98bb2ff33" => :sierra
  end

  keg_only :versioned_formula

  option "with-rtmpdump", "Enable RTMP protocol"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-opencore-amr", "Enable Opencore AMR NR/WB audio format"
  option "with-openjpeg", "Enable JPEG 2000 image format"
  option "with-openssl", "Enable SSL support"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-libvidstab", "Enable vid.stab support for video stabilization"
  option "with-libsoxr", "Enable the soxr resample library"
  option "with-webp", "Enable using libwebp to encode WEBP images"
  option "with-zeromq", "Enable using libzeromq to receive commands sent through a libzeromq client"
  option "with-dcadec", "Enable dcadec library"

  depends_on "pkg-config" => :build
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "lame"
  depends_on "libvo-aacenc"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "sdl"
  depends_on "snappy"
  depends_on "theora"
  depends_on "x264"
  depends_on "x265"
  depends_on "xvid"

  depends_on "dcadec" => :optional
  depends_on "faac" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "fontconfig" => :optional
  depends_on "freetype" => :optional
  depends_on "frei0r" => :optional
  depends_on "libass" => :optional
  depends_on "libbluray" => :optional
  depends_on "libbs2b" => :optional
  depends_on "libcaca" => :optional
  depends_on "libquvi" => :optional
  depends_on "libsoxr" => :optional
  depends_on "libssh" => :optional
  depends_on "libvidstab" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openjpeg" => :optional
  depends_on "openssl" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "speex" => :optional
  depends_on "webp" => :optional
  depends_on "zeromq" => :optional

  def install
    # Fixes "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace %w[libavdevice/v4l2.c libavutil/time.c], "HAVE_CLOCK_GETTIME",
                                                         "UNDEFINED_GIBBERISH"
    end

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
    ]

    args << "--enable-opencl" if MacOS.version > :lion
    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libschroedinger" if build.with? "schroedinger"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-openssl" if build.with? "openssl"
    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libsoxr" if build.with? "libsoxr"
    args << "--enable-libquvi" if build.with? "libquvi"
    args << "--enable-libvidstab" if build.with? "libvidstab"
    args << "--enable-libwebp" if build.with? "webp"
    args << "--enable-libzmq" if build.with? "zeromq"
    args << "--enable-libbs2b" if build.with? "libbs2b"
    args << "--enable-libdcadec" if build.with? "dcadec"

    if build.with? "openjpeg"
      args << "--enable-libopenjpeg"
      args << "--disable-decoder=jpeg2000"
      args << "--extra-cflags=" + `pkg-config --cflags libopenjpeg`.chomp
    end

    # These librares are GPL-incompatible, and require ffmpeg be built with
    # the "--enable-nonfree" flag, which produces unredistributable libraries
    if %w[faac fdk-aac openssl].any? { |f| build.with? f }
      args << "--enable-nonfree"
    end

    # A bug in a dispatch header on 10.10, included via CoreFoundation,
    # prevents GCC from building VDA support. GCC has no problems on
    # 10.9 and earlier.
    # See: https://github.com/Homebrew/homebrew/issues/33741
    if MacOS.version < :yosemite || ENV.compiler == :clang
      args << "--enable-vda"
    else
      args << "--disable-vda"
    end

    system "./configure", *args

    inreplace "config.mak" do |s|
      shflags = s.get_make_var "SHFLAGS"
      if shflags.gsub!(" -Wl,-read_only_relocs,suppress", "")
        s.change_make_var! "SHFLAGS", shflags
      end
    end

    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }
  end

  test do
    # Create an example mp4 file
    system "#{bin}/ffmpeg", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert_predicate testpath/"video.mp4", :exist?
  end
end
