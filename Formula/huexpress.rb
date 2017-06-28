class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.3.tar.gz"
  sha256 "159a13cd469d0645377377604c0fc4b3d3d1980d4d0e71c634c293f99db2c497"
  revision 2
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    sha256 "1cdd931e7b87a37d41aafc6b2c6b9809cac5ed245b9238e8b9e353467206e553" => :sierra
    sha256 "acf49ec01f3711b8efd5ff085f62946bd43da4325c93cccbb3d6eb9159f6e7e7" => :el_capitan
    sha256 "1bf4ccbc2e318b79d3b210b02a97e2dd425316ccdf1caccc611bbede117e142a" => :yosemite
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
