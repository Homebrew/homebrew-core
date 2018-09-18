class Libav < Formula
  desc "Audio and video processing tools"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.3.tar.xz"
  sha256 "6893cdbd7bc4b62f5d8fd6593c8e0a62babb53e323fbc7124db3658d04ab443b"
  head "https://git.libav.org/libav.git"

  bottle do
    sha256 "8f3f04d727b845937602d7da62961d6bfd83155bb564786f18536af119975cee" => :mojave
    sha256 "84c3c2aa4f5cd7086021bb7c30215e872a1c4e3005df914b240696162ce3e8f6" => :high_sierra
    sha256 "fc68fd70481e6071b567bc186df5d39b3156f0053f98ef0bdeda020497beb11d" => :sierra
    sha256 "d91489215ba05ef1a9c93c3c18d6c13e20fdc901fad4e9d6c47922775be77ecb" => :el_capitan
  end

  option "with-openssl", "Enable SSL support"
  option "with-sdl", "Enable avplay"
  option "with-theora", "Enable Theora encoding via libtheora"

  depends_on "pkg-config" => :build
  # manpages won't be built without texi2html
  depends_on "texi2html" => :build if MacOS.version >= :mountain_lion
  depends_on "yasm" => :build

  depends_on "faac"
  depends_on "fdk-aac"
  depends_on "freetype"
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "x264"
  depends_on "xvid"

  depends_on "openssl" => :optional
  depends_on "sdl" => :optional
  depends_on "theora" => :optional

  # https://bugzilla.libav.org/show_bug.cgi?id=1033
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b6e917c/libav/Check-for--no_weak_imports-in-ldflags-on-macOS.patch"
    sha256 "986d748ba2c7c83319a59d76fbb0dca22dcd51f0252b3d1f3b80dbda2cf79742"
  end

  def install
    args = %W[
      --disable-debug
      --disable-shared
      --disable-indev=jack
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-gpl
      --enable-libfaac
      --enable-libfdk-aac
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopus
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libxvid
      --enable-nonfree
      --enable-vda
      --enable-version3
    ]

    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-openssl" if build.with? "openssl"

    system "./configure", *args

    system "make"

    bin.install "avconv", "avprobe"
    man1.install "doc/avconv.1", "doc/avprobe.1"
    if build.with? "sdl"
      bin.install "avplay"
      man1.install "doc/avplay.1"
    end
  end

  test do
    # Create an example mp4 file
    system "#{bin}/avconv", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert_predicate testpath/"video.mp4", :exist?
  end
end
