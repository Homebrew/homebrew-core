class Mythtv < Formula
  desc "MythTV"
  homepage "https://www.mythtv.org"
  url "https://www.mythtv.org/download/mythtv/29"
  sha256 "8ab2423e78974e96fd5f85efb05633897167791c80ba75f198735b9a54ca0bc8"
  depends_on "taglib"
  depends_on "exiv2"
  depends_on "qt"
  depends_on "fftw"
  depends_on "x265"
  depends_on "x264"
  depends_on "pkg-config"
  depends_on "yasm"
  depends_on "xz"
  depends_on "freetype"
  depends_on "libass"
  depends_on "zlib"
  depends_on "bzip2"
  depends_on "lame"
  depends_on "libiconv"
  depends_on "libxml2"
  depends_on "openssl"
  patch do
    url "https://gist.githubusercontent.com/mmisiewicz/b7f974e1f315f2e78019314a445cd61c/raw/bfb855e4bf0d5a1a7cb0d03efc8458f71163b82f/myth_qtwebkit_option.diff"
    sha256 "05b800b1daa1367c40edae41fbcd605edf462124995c67c8da7a23d65bfc8c52"
  end
  
  def install
    extraincludes = "-I#{Formula["fftw"].opt_prefix}/include "
    extraincludes += "-I#{Formula["openssl"].opt_prefix}/include "
    extraincludes += "-I#{Formula["libass"].opt_prefix}/include "
    extraincludes += "-I#{Formula["lame"].opt_prefix}/include "
    extraincludes += "-I#{Formula["exiv2"].opt_prefix}/include "
    extraincludes += "-I#{Formula["taglib"].opt_prefix}/include "
    extraincludes += "-I#{Formula["x265"].opt_prefix}/include "
    extraincludes += "-I#{Formula["x264"].opt_prefix}/include "
    extraincludes += "-I#{Formula["xz"].opt_prefix}/include "
    extraincludes += "-I#{Formula["zlib"].opt_prefix}/include "
    extraincludes += "-I#{Formula["bzip2"].opt_prefix}/include "
    extraincludes += "-I#{Formula["libiconv"].opt_prefix}/include "
    extraldflags = "-L#{Formula["fftw"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["openssl"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["libass"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["lame"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["exiv2"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["taglib"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["x265"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["x264"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["xz"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["zlib"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["bzip2"].opt_prefix}/lib "
    extraldflags += "-L#{Formula["libiconv"].opt_prefix}/lib "
    
    ENV.append_to_cflags extraincludes
    ENV.append "LDFLAGS", extraldflags
    
    qmakearg = "--qmake=#{Formula["qt"].opt_prefix}/bin/qmake"
    cd "mythtv"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--extra-cxxflags=#{extraincludes}",
                          "--extra-cflags=#{extraincludes}",
                          qmakearg,
                          "--python=#{HOMEBREW_PREFIX}/bin/python",
                          "--disable-mythlogserver",
                          "--disable-ceton",
                          "--disable-firewire",
                          "--disable-audio-jack",
                          "--disable-indev=jack",
                          "--disable-audio-pulseoutput",
                          "--disable-gnutls",
                          "--disable-libcec",
                          "--disable-libpulse",
                          "--disable-libvpx",
                          "--disable-libxcb",
                          "--disable-libxvid",
                          "--disable-lzma",
                          "--disable-qtdbus",
                          "--disable-sdl",
                          "--disable-systemd_notify",
                          "--disable-videotoolbox",
                          "--disable-xlib",
                          "--disable-xrandr",
                          "--disable-xv",
                          "--enable-iconv",
                          "--enable-fft",
                          "--enable-libmp3lame",
                          "--enable-libass",
                          "--enable-libx264",
                          "--enable-nonfree",
                          "--enable-libx265",
                          "--enable-securetransport",
                          "--enable-zlib",
                          "--disable-qtwebkit"
    system "make", "install"
  end
  
  def caveats; <<~EOS
    During the compile, there may be conflicts with MythTV's own ffmpeg. `brew remove ffmpeg` before installing MythTv. It can be reinstalled after.
    In order for the python MythTV library to compile, you must install the packages: `python-mysql`, `pycurl` and `urlgrabber` using pip. PyCurl requires a special install: `  PYCURL_SSL_LIBRARY=openssl LDFLAGS=-L/usr/local/opt/openssl/lib CPPFLAGS=-I/usr/local/opt/openssl/include pip install pycurl --compile --no-cache-dir`.
    `Qt` must be installed with MySQL support. `brew install qt --with-mysql`.
    EOS
  end
  
  test do
    system "#{bin}/mythbackend", "--help"
    system "#{bin}/mythfrontend", "--help"
    system "true"
  end
end
