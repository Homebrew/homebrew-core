class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.3.tar.gz"
  sha256 "159a13cd469d0645377377604c0fc4b3d3d1980d4d0e71c634c293f99db2c497"
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    sha256 "aefa69c1df19635a784390e259890ca2107bf66a390c7e84bfd9f51c042f150a" => :el_capitan
    sha256 "25302596add34af85e0381d09a363f1789becf9378b0181253867e418e83c935" => :yosemite
    sha256 "5e85cb80e11a1d57413ae5d33321b773712cdafee692cef68082a748ec4affdd" => :mavericks
  end

  depends_on "scons" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_mixer" => "with-libvorbis"
  depends_on "libvorbis"
  depends_on "libzip"

  def install
    scons
    bin.install ["src/huexpress", "src/hucrc"]
  end

  test do
    assert_match /Version #{version}$/, shell_output("#{bin}/huexpress -h", 1)
  end
end
