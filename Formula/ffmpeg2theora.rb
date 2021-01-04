class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 9
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git"

  bottle do
    cellar :any
    sha256 "914a37d9ae9fa3a53d0031d0ad74ff845ab697ebdc3cbf49a5779fdc612019b1" => :big_sur
    sha256 "798941bd62632faa2ba60e15946b283e8ff25746506c014ec76ff35d41ad92fd" => :arm64_big_sur
    sha256 "c528b2081e23bf7f61a613e3d1a806063a588cac7221eb8cfb3498c677a70ca9" => :catalina
    sha256 "409ecd351e9dd14422899583335fca3d7f49c3c605cbd2dda692fab55935b279" => :mojave
    sha256 "69208fef6137d77c75ff41f2cdc3154cf33516de1b60b20d243d99872729c06b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg"
  depends_on "libkate"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  # Use python3 print()
  patch do
    url "https://salsa.debian.org/multimedia-team/ffmpeg2theora/-/raw/master/debian/patches/0002-Use-python3-print.patch"
    sha256 "8cf333e691cf19494962b51748b8246502432867d9feb3d7919d329cb3696e97"
  end

  def install
    # Fix unrecognized "PRId64" format specifier
    inreplace "src/theorautils.c", "#include <limits.h>", "#include <limits.h>\n#include <inttypes.h>"

    args = [
      "prefix=#{prefix}",
      "mandir=PREFIX/share/man",
      "APPEND_LINKFLAGS=-headerpad_max_install_names",
    ]
    system "scons", "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
