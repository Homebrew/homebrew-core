class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://gitlab.xiph.org/xiph/ffmpeg2theora"
  url "https://gitlab.xiph.org/xiph/ffmpeg2theora/-/archive/0.30/ffmpeg2theora-0.30.tar.gz"
  sha256 "9bc69b7c3430184e8e74d648e39bd8a35a8bb10e9e6d6d5750f334c4feaca8d6"
  license "GPL-2.0-or-later"
  revision 12
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42c00e60ebc22a03002de781c194a5bb837e0528fa92c32f89dd65a60c375757"
    sha256 cellar: :any,                 arm64_sequoia: "f80e6c1cf50dee0a7bc77cd75c58c10814972804cad86dc8c9167e03d6f1fa0b"
    sha256 cellar: :any,                 arm64_sonoma:  "bb6bc8a440306ed6db8686afaed5733dc4044ca647343c81875c3e4089e9d218"
    sha256 cellar: :any,                 arm64_ventura: "66a8239374c87df7e683e03192bb818a207b9f8cea5e7ebefe6d7e51d6e91d40"
    sha256 cellar: :any,                 sonoma:        "c9af8b3a5b08e30151a56e2a58356d27ff7f37cf6418f622d0024d02ff7077ff"
    sha256 cellar: :any,                 ventura:       "032d3f203c4ae3ef2da43b4e16702586a081f101ae719ac211698df4039c922c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f691b49ee844e7e946caf574c177c1e9389f9714aa18b3289d1b02337bace8b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af084dab0150730e9197bd8c8d3ba09eb0aef171742918f257aabead5b5a664e"
  end

  depends_on "pkgconf" => :build
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
    system bin/"ffmpeg2theora", "--help"
  end
end
