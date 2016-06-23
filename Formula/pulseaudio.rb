class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-9.0.tar.xz"
  sha256 "c3d3d66b827f18fbe903fe3df647013f09fc1e2191c035be1ee2d82a9e404686"

  bottle do
    revision 1
    sha256 "ec432b0c8e3462f1e8c66b3042ac55f64fa0f050797a6a21914766dd649c15b0" => :el_capitan
    sha256 "7c904d263248a34400e7014542b2fc966b375959a8ed86cd48619c4aaa4b4534" => :yosemite
    sha256 "95fd865d58978d8f06e76e8ed49893b45f37b69656d831d6c66cfd28a0b6495c" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  option "with-nls", "Build with native language support"
  option :universal

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

  depends_on :x11 => :optional
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "dbus" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional

  # i386 patch per MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/15fa4f03/pulseaudio/i386.patch"
    sha256 "d3a2180600a4fbea538949b6c4e9e70fe7997495663334e50db96d18bfb1da5f"
  end

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
      --with-mac-sysroot=/
    ]

    args << "--with-mac-sysroot=#{MacOS.sdk_path}"
    args << "--with-mac-version-min=#{MacOS.version}"
    args << "--disable-nls" if build.without? "nls"

    if build.universal?
      args << "--enable-mac-universal"
      ENV.universal_binary
    end

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
