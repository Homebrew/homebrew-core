class Libsamplerate < Formula
  desc "Library for sample rate conversion of audio data"
  homepage "http://www.mega-nerd.com/SRC"
  url "http://www.mega-nerd.com/SRC/libsamplerate-0.1.9.tar.gz"
  sha256 "0a7eb168e2f21353fb6d84da152e4512126f7dc48ccb0be80578c565413444c1"

  bottle do
    cellar :any
    sha256 "9889af1465dd3eccbed2f532a94ce85543ec0e79984f879bdc60ad9e89478fc2" => :mojave
    sha256 "b7e0343483287deebebd335de03c5c3a4597334440cc01dc1dbd5d14cc6505d8" => :high_sierra
    sha256 "69443b5047dc7e71b74ec29359b1d05e3e6c659751b73a3c2e8e0ad4dd63a6f1" => :sierra
    sha256 "97e0ba8a07df0684580bfec1a7fc5760d1f90e9102330ced19cdb7c37c4ae0ca" => :el_capitan
    sha256 "5f3623588a4fb9b2d886547719d0a3b68df725882d329152ee1de7c4841404ed" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "fftw" => :optional
  depends_on "libsndfile" => :optional

  # configure adds `/Developer/Headers/FlatCarbon` to the include, but this is
  # very deprecated. Correct the use of Carbon.h to the non-flat location.
  # See: https://github.com/Homebrew/homebrew/pull/10875
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # https://github.com/Homebrew/homebrew/issues/47133
    # Unless formula is built with libsndfile, the example program is broken.
    rm_f "#{bin}/sndfile-resample" if build.without? "libsndfile"
  end

  def caveats
    s = ""
    if build.without? "libsndfile"
      s += <<~EOS
        Unless this formula is built with libsndfile, the example program,
        "sndfile-resample", is broken and hence, removed from installation.
      EOS
    end
    s
  end
end

__END__
--- a/examples/audio_out.c	2011-07-12 16:57:31.000000000 -0700
+++ b/examples/audio_out.c	2012-03-11 20:48:57.000000000 -0700
@@ -168,7 +168,7 @@
 
 #if (defined (__MACH__) && defined (__APPLE__)) /* MacOSX */
 
-#include <Carbon.h>
+#include <Carbon/Carbon.h>
 #include <CoreAudio/AudioHardware.h>
 
 #define	MACOSX_MAGIC	MAKE_MAGIC ('M', 'a', 'c', ' ', 'O', 'S', ' ', 'X')
