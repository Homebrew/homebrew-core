class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 6
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git"

  bottle do
    cellar :any
    sha256 "8c9c5de4f7abb7aff89f0d29a5234e549dc9a3ab8a58f7dbc79ef84e290cf3c9" => :catalina
    sha256 "955b11ab8815ad86a02fdd7f7454880108a191d8b406c499b5d5314f4498656c" => :mojave
    sha256 "f91d9c881ea674c6b6b02f83a6ef53c6e30554c7b2828a9e706eb38cce33220f" => :high_sierra
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
