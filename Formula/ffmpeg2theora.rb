class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 10
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git", branch: "master"

  livecheck do
    url "http://v2v.cc/~j/ffmpeg2theora/download.html"
    regex(/href=.*?ffmpeg2theora[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fda3d3ece47a930bb675a3bfcf9bb9f9565ee64ffb8249ec1b282dc52d886b15"
    sha256 cellar: :any,                 arm64_big_sur:  "821bc4ec0b0900b41bc8236edfba9087b0637ddccbb58b60bf393f96177d6858"
    sha256 cellar: :any,                 monterey:       "c1da252c4ada9b2dc39ae83a1af5d1d2a449191173a35a2fb05c1667224fada9"
    sha256 cellar: :any,                 big_sur:        "83c525d0923c3b2b550e00b78dd6257dc4ff4ed9639464e6d360ed6784b9d09e"
    sha256 cellar: :any,                 catalina:       "33be387b709b49ebd87f07c95f396b24aabbe09dc4ee74d71067b08ae13978a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e1607b67fd2b486a89e6eff86cea8f05f5715b93baef49aa839ab844f71c43"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg@4"
  depends_on "libkate"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
