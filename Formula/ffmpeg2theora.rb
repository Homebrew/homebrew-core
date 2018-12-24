class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 4
  head "https://git.xiph.org/ffmpeg2theora.git"

  bottle do
    cellar :any
    sha256 "110c82493cedbf7b5c1ba0840eb5a01d33ace587db01fc1ed4e9707073a21322" => :mojave
    sha256 "5fb50e2d8436ef85aa47efca7494e0d25f43e46a1f66895d1457771a65b08f6b" => :high_sierra
    sha256 "5bd541db8f60a4f6a432794c800c8a6fc68cd74e5a96ca6547bdfc5cc64e4b1f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "ffmpeg"
  depends_on "libkate"
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
