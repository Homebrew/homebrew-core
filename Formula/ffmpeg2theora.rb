class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 9
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "90738560daa49a15f7aabf51be18dd1ce4f4c748c35c669b279e394853200a89"
    sha256 cellar: :any, arm64_big_sur:  "114e5f48ead0a1375f4dab1217723fe5f6850529ee5fc3f5fe4042295adf327a"
    sha256 cellar: :any, monterey:       "21653a640f0a30053b39798bb6c4b6755c36dc30db63621f3c5666a04516d114"
    sha256 cellar: :any, big_sur:        "1c2718b1a6c348dfceaeef1bd155b6caf385cf4756feefb568cb6f42a6f099e2"
    sha256 cellar: :any, catalina:       "05f0fb622f434c062ea69f39a09ea1db62824efb26fcb8adf0921600785e0b3c"
    sha256 cellar: :any, mojave:         "30967cb12c298c6441bb8f4d283a9659c314639cc0409a1a446cb1a80216a31b"
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
