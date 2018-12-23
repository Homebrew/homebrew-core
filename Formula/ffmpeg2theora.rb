class Ffmpeg2theora < Formula
  desc "Convert video files to Ogg Theora format"
  homepage "https://v2v.cc/~j/ffmpeg2theora/"
  url "https://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.30.tar.bz2"
  sha256 "4f6464b444acab5d778e0a3359d836e0867a3dcec4ad8f1cdcf87cb711ccc6df"
  revision 4
  head "https://git.xiph.org/ffmpeg2theora.git"

  bottle do
    cellar :any
    sha256 "b151520e1a7c211f7e488564a9293f4c1e80de0913ec2bac633d688b14ecf6f0" => :mojave
    sha256 "a0caf912922e2a78d18af10724df81befd8f7e672dc5173cee4d0b29cd482257" => :high_sierra
    sha256 "8759af5194f13281394af44330ef522186f6d68fc12e2036c235df4894be376c" => :sierra
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
