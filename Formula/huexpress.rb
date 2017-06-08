class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.3.tar.gz"
  sha256 "159a13cd469d0645377377604c0fc4b3d3d1980d4d0e71c634c293f99db2c497"
  revision 1
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    sha256 "cf0ed74cfe5407985ef14c807cea97ce85e3ed1b156fc5634ba5d16841cfffff" => :sierra
    sha256 "a3cc21304fdd6906df6f1a8bbf7f2ae3a467b906ec81df725f8a9b85431dc1e3" => :el_capitan
    sha256 "74672f9c6a4efa91a47184edd67d5a4356d47f8acaf663e53543be24598e1c90" => :yosemite
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
