class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.3.tar.gz"
  sha256 "159a13cd469d0645377377604c0fc4b3d3d1980d4d0e71c634c293f99db2c497"
  revision 2
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    sha256 "af1a3a21d9c2167664e0bc23fbe30f2c5b8fbbad3f2b6a0b2a0e6077a9c15fb5" => :sierra
    sha256 "6e45f3422330caa85b0fb0f728354f4055fa6c3b1d67783003521f6082fe8a18" => :el_capitan
    sha256 "baf345f364a3982d2d32dbe643b1920bef35ea66cb51e1c895e99c6845d4e0a8" => :yosemite
  end

  depends_on "scons" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_mixer"
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
