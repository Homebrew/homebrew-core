class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  revision 3

  stable do
    url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
    sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"

    depends_on "libkate" => :optional
  end

  bottle do
    cellar :any
    sha256 "a517dd9bad22e77eb93ca62d3ad06f47f2a75c0104e651ae610b12158e9b1788" => :mojave
    sha256 "e77079f5d599e4caeb3db3892d16234436918a6c4d8fe2cb2adb3b263ca57250" => :high_sierra
    sha256 "f3dac1a662858bce6a7249233075612405fc438e78d81c4076daeb0e15d445db" => :sierra
    sha256 "a85645fc31da1e0180c316eb93f8ad54e903d4c61bf3ef42aab17e5d6b5cd21c" => :el_capitan
  end

  head do
    url "https://git.xiph.org/ffmpeg2theora.git"

    depends_on "libkate" => :recommended
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "theora"

  def install
    args = [
      "prefix=#{prefix}",
      "mandir=PREFIX/share/man",
      "APPEND_LINKFLAGS=-headerpad_max_install_names",
    ]
    scons "install", *args
  end

  test do
    system "#{bin}/ffmpeg2theora", "--help"
  end
end
