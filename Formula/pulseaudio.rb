class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-10.0.tar.xz"
  sha256 "a3186824de9f0d2095ded5d0d0db0405dc73133983c2fbb37291547e37462f57"
  revision 2

  bottle do
    sha256 "dd04c95709c64a4ea74cfa929d0dc2ddc6fd9473df163bf7e72310baa22b1653" => :sierra
    sha256 "22eb7493320be8bf4c41ed227149d045eaffb8c132df9b8ad8b7b69ed3e085ce" => :el_capitan
    sha256 "657b7acd39bbc8ccd790fed5396ff3b5de08667f039cabe7481cc259ddb6f005" => :yosemite
  end

  head do
    url "https://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  option "with-nls", "Build with native language support"

  deprecated_option "without-speex" => "without-speexdsp"

  depends_on "pkg-config" => :build

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libtool" => :run
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "openssl"
  depends_on "dbus" => :recommended
  depends_on "speexdsp" => :recommended
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional
  depends_on "fftw" => :optional

  fails_with :clang do
    build 421
    cause "error: thread-local storage is unsupported for the current target"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-coreaudio-output
      --disable-neon-opt
      --with-mac-sysroot=#{MacOS.sdk_path}
      --with-mac-version-min=#{MacOS.version}
      --disable-x11
    ]

    args << "--disable-nls" if build.without? "nls"
    args << "--disable-dbus" if build.without? "dbus"
    args << "--disable-glib2" if build.without? "glib"
    args << "--disable-gtk3" if build.without? "gtk+3"
    args << "--disable-gconf" if build.without? "gconf"
    args << "--disable-jack" if build.without? "jack"
    args << "--without-fftw" if build.without? "fftw"

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"pulseaudio", "--dump-modules"
  end
end
