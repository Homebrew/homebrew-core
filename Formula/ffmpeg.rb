class Ffmpeg < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"

  stable do
    url "https://ffmpeg.org/releases/ffmpeg-3.1.4.tar.bz2"
    sha256 "7c99df75a4dc12d22c0f1ed11d0acf98cac1f8b5fe7a7434344b167f810bcbfa"

    option "with-sdl", "Enable FFplay media player"
    option "with-openh264", "Enable OpenH264 library"
    deprecated_option "with-ffplay" => "with-sdl"

    depends_on "sdl" => :optional
    depends_on "nasm" => :build if build.with? "openh264"

    # Remove when ffmpeg has support for openh264 1.6.0
    # See https://github.com/cisco/openh264/issues/2505
    # Master now has support, but not the 3.1.x branch
    resource "openh264-1.5.0" do
      url "https://github.com/cisco/openh264/archive/v1.5.0.tar.gz"
      sha256 "98077bd5d113c183ce02b678733b0cada2cf36750370579534c4d70f0b6c27b5"
    end
  end

  bottle do
    rebuild 1
    sha256 "7a2846c8ff8deac59889d6c14ea5fc2f09948d90c5829c3487666474bf2d6be1" => :sierra
    sha256 "22ed651c7e2f672987b90b8c5190b26ab6972f07facb29385c04965ab68d2041" => :el_capitan
    sha256 "7d8705414f95856ec1335b11e97a6426c03c9937ad401ff4ba422123d45619d2" => :yosemite
  end

  head do
    url "https://github.com/FFmpeg/FFmpeg.git"

    # Support for SDL1 has been removed from master
    option "with-sdl2", "Enable FFplay media player"
    deprecated_option "with-ffplay" => "with-sdl2"

    depends_on "sdl2" => :optional
    depends_on "openh264" => :optional
  end

  option "without-x264", "Disable H.264 encoder"
  option "without-lame", "Disable MP3 encoder"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder"
  option "without-qtkit", "Disable deprecated QuickTime framework"

  option "with-rtmpdump", "Enable RTMP protocol"
  option "with-libass", "Enable ASS/SSA subtitle format"
  option "with-opencore-amr", "Enable Opencore AMR NR/WB audio format"
  option "with-openjpeg", "Enable JPEG 2000 image format"
  option "with-openssl", "Enable SSL support"
  option "with-libssh", "Enable SFTP protocol via libssh"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-tools", "Enable additional FFmpeg tools"
  option "with-fdk-aac", "Enable the Fraunhofer FDK AAC library"
  option "with-libvidstab", "Enable vid.stab support for video stabilization"
  option "with-x265", "Enable x265 encoder"
  option "with-libsoxr", "Enable the soxr resample library"
  option "with-webp", "Enable using libwebp to encode WEBP images"
  option "with-zeromq", "Enable using libzeromq to receive commands sent through a libzeromq client"
  option "with-snappy", "Enable Snappy library"
  option "with-rubberband", "Enable rubberband library"
  option "with-zimg", "Enable z.lib zimg library"
  option "with-xz", "Enable decoding of LZMA-compressed TIFF files"
  option "with-libebur128", "Enable using libebur128 for EBU R128 loudness measurement"

  depends_on "pkg-config" => :build

  # manpages won't be built without texi2html
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "x264" => :recommended
  depends_on "lame" => :recommended
  depends_on "xvid" => :recommended

  depends_on "faac" => :optional
  depends_on "fontconfig" => :optional
  depends_on "freetype" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional
  depends_on "libvpx" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "libass" => :optional
  depends_on "openjpeg" => :optional
  depends_on "snappy" => :optional
  depends_on "speex" => :optional
  depends_on "schroedinger" => :optional
  depends_on "fdk-aac" => :optional
  depends_on "opus" => :optional
  depends_on "frei0r" => :optional
  depends_on "libcaca" => :optional
  depends_on "libbluray" => :optional
  depends_on "libsoxr" => :optional
  depends_on "libvidstab" => :optional
  depends_on "x265" => :optional
  depends_on "openssl" => :optional
  depends_on "libssh" => :optional
  depends_on "webp" => :optional
  depends_on "zeromq" => :optional
  depends_on "libbs2b" => :optional
  depends_on "rubberband" => :optional
  depends_on "zimg" => :optional
  depends_on "xz" => :optional
  depends_on "libebur128" => :optional

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
    ]

    if build.with? "openh264"
      if build.stable?
        resource("openh264-1.5.0").stage do
          system "make", "install-shared", "PREFIX=#{libexec}/openh264-1.5.0"
        end
        ENV.prepend_path "PKG_CONFIG_PATH", libexec/"openh264-1.5.0/lib/pkgconfig"
      end
      args << "--enable-libopenh264"
    end

    args << "--enable-opencl" if MacOS.version > :lion

    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-libsnappy" if build.with? "snappy"

    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-libopencore-amrnb" << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libass" if build.with? "libass"
    args << "--enable-ffplay" if build.with? "ffplay"
    args << "--enable-libssh" if build.with? "libssh"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libschroedinger" if build.with? "schroedinger"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-openssl" if build.with? "openssl"
    args << "--enable-libopus" if build.with? "opus"
    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-libcaca" if build.with? "libcaca"
    args << "--enable-libsoxr" if build.with? "libsoxr"
    args << "--enable-libvidstab" if build.with? "libvidstab"
    args << "--enable-libx265" if build.with? "x265"
    args << "--enable-libwebp" if build.with? "webp"
    args << "--enable-libzmq" if build.with? "zeromq"
    args << "--enable-libbs2b" if build.with? "libbs2b"
    args << "--enable-librubberband" if build.with? "rubberband"
    args << "--enable-libzimg" if build.with? "zimg"
    args << "--disable-indev=qtkit" if build.without? "qtkit"
    args << "--enable-libebur128" if build.with? "libebur128"

    if build.with? "xz"
      args << "--enable-lzma"
    else
      args << "--disable-lzma"
    end

    if build.with? "openjpeg"
      args << "--enable-libopenjpeg"
      args << "--disable-decoder=jpeg2000"
      args << "--extra-cflags=" + `pkg-config --cflags libopenjp2`.chomp
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

    # For 32-bit compilation under gcc 4.2, see:
    # https://trac.macports.org/ticket/20938#comment:22
    ENV.append_to_cflags "-mdynamic-no-pic" if Hardware::CPU.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace "config.mak" do |s|
        shflags = s.get_make_var "SHFLAGS"
        if shflags.gsub!(" -Wl,-read_only_relocs,suppress", "")
          s.change_make_var! "SHFLAGS", shflags
        end
      end
    end

    system "make", "install"

    if build.with? "tools"
      system "make", "alltools"
      bin.install Dir["tools/*"].select { |f| File.executable? f }
    end
  end

  def caveats
    if build.without? "faac" then <<-EOS.undent
      The native FFmpeg AAC encoder has been stable since FFmpeg 3.0. If you
      were using libvo-aacenc or libaacplus, both of which have been dropped in
      FFmpeg 3.0, please consider switching to the native encoder (-c:a aac),
      fdk-aac (-c:a libfdk_aac, ffmpeg needs to be installed with the
      --with-fdk-aac option), or faac (-c:a libfaac, ffmpeg needs to be
      installed with the --with-faac option).

      See the announcement
      https://ffmpeg.org/index.html#removing_external_aac_encoders for details,
      and https://trac.ffmpeg.org/wiki/Encode/AAC on best practices of encoding
      AAC with FFmpeg.
      EOS
    end
  end

  test do
    # Create an example mp4 file
    system "#{bin}/ffmpeg", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert (testpath/"video.mp4").exist?
  end
end
