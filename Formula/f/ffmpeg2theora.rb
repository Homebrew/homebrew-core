class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://gitlab.xiph.org/xiph/ffmpeg2theora"
  url "https://gitlab.xiph.org/xiph/ffmpeg2theora/-/archive/0.30/ffmpeg2theora-0.30.tar.gz"
  sha256 "9bc69b7c3430184e8e74d648e39bd8a35a8bb10e9e6d6d5750f334c4feaca8d6"
  license "GPL-2.0-or-later"
  revision 11
  head "https://gitlab.xiph.org/xiph/ffmpeg2theora.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "386bcf4220cfa4e2aa06f1a9fa920cbd028d321bf622f3b7c1010d63502ce584"
    sha256 cellar: :any,                 arm64_sonoma:   "db8c87aecac7f8ee1585140a11fba27cbc9f570662c646403b3a1363c3ae65d4"
    sha256 cellar: :any,                 arm64_ventura:  "ef0f30079f953e5f616f0033ceca1b46d7fa0152977890fa27da10b11de53998"
    sha256 cellar: :any,                 arm64_monterey: "23e95a08aeabf87d68743c06cffd1d27d054cc9aa7805fe5ab1f6eab1b121fe8"
    sha256 cellar: :any,                 sonoma:         "2033b5b0ee57ebcca4884fbe0bb3b18e91a13d0714f4854e3ebe0535345c6ce7"
    sha256 cellar: :any,                 ventura:        "ce42df594f3605668d80f8bf4f9f8d40c2f2c9ce8bb295f213cbf9d313f54227"
    sha256 cellar: :any,                 monterey:       "7d9478e2bb76d731a905685b690d4663975959ad8a07c45e60fe19acce323aab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3965a87c59f7e76f5440130868ad518c5e770a786e5074bb3803cc88c627c024"
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
    system bin/"ffmpeg2theora", "--help"
  end
end
