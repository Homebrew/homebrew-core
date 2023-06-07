class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  license "GPL-2.0-or-later"
  revision 10
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git", branch: "master"

  livecheck do
    url "http://v2v.cc/~j/ffmpeg2theora/download.html"
    regex(/href=.*?ffmpeg2theora[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "ed8a59898f63352760fda9707681ac0f4ef597ffbb5ec145a01649845d5e28b7"
    sha256 cellar: :any,                 arm64_monterey: "4e5863d4eeb81f57e4a2517beba074e4a9bb560ad14965e5e2b3a1f9f71048e9"
    sha256 cellar: :any,                 arm64_big_sur:  "cf6ce000803f27ce6e818c8636f1252407ed32cd5ca0e5767a156db20414a07d"
    sha256 cellar: :any,                 ventura:        "1093fbdcd773268b0b558c9d8a2e2d5e269aa2cb701c1f9f7402df0fb974492f"
    sha256 cellar: :any,                 monterey:       "1151e536437a26d846bd7abd608dd60ee80f81bcbbeca84afd1d6739c5d1373c"
    sha256 cellar: :any,                 big_sur:        "6ae499a21d16ad1de2cc39c39180bd6fe0c96864227147480c1bec7c218201f9"
    sha256 cellar: :any,                 catalina:       "f07b22467dc83816cf815408371d7d78f73f3bcaeef43c0c6bf50339d3c94c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ef3694734992a098accb3e46e9f5c4222b16733af0ec708a8ac2a6dac48360"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg@4"
  depends_on "libkate"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  # Use python3 print()
  patch do
    url "https://salsa.debian.org/multimedia-team/ffmpeg2theora/-/raw/master/debian/patches/0002-Use-python3-print.patch"
    sha256 "8cf333e691cf19494962b51748b8246502432867d9feb3d7919d329cb3696e97"
  end

  # Fix missing linker flags
  patch do
    url "https://salsa.debian.org/multimedia-team/ffmpeg2theora/-/raw/debian/0.30-2/debian/patches/link-libm.patch"
    sha256 "1cf00c93617ecc4833e9d2267d68b70eeb6aa6183f0c939f7caf0af5ce8460b5"
  end

  def install
    # Fix unrecognized "PRId64" format specifier
    inreplace "src/theorautils.c", "#include <limits.h>", "#include <limits.h>\n#include <inttypes.h>"

    args = [
      "prefix=#{prefix}",
      "mandir=PREFIX/share/man",
    ]
    if OS.mac?
      args << "APPEND_LINKFLAGS=-headerpad_max_install_names"
    else
      gcc_version = Formula["gcc"].version.major
      rpaths = "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib -Wl,-rpath,#{Formula["ffmpeg@4"].opt_lib}"
      args << "APPEND_LINKFLAGS=-L#{Formula["gcc"].opt_lib}/gcc/#{gcc_version} -lstdc++ #{rpaths}"
    end
    system "scons", "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
