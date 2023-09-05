class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.4.tar.gz"
  sha256 "76589f02d1640fc5063d48a47f017077c6b7557431221defe9e38679d86d4db8"
  license "GPL-2.0"
  revision 2
  head "https://github.com/kallisti5/huexpress.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d69fc8ce360f304a6c9e95a8120196d5efaec9f77f02a82b0e5c3e4cab6b84da"
    sha256 cellar: :any, arm64_monterey: "a0919bd5024f7f197c262f0ba1dd5c57871506308bd7a4bfd98b5f18f04dbb50"
    sha256 cellar: :any, arm64_big_sur:  "2709e20246d6ab1a14329ccc842e49eefd9276c6b1e3ef90bcadc85c2213a394"
    sha256 cellar: :any, ventura:        "3fc6ef796681ae0b49b2f6386add406c8ace5aa450160b2530fe0174205d6b7e"
    sha256 cellar: :any, monterey:       "5c02e7de59a65392f1347c65df445e2d447daaac2eb508c920f8ce452628dbd5"
    sha256 cellar: :any, big_sur:        "37272d08ed74984450ae2f08e17e9b41fdf32cc487aee1c0ab0832c10177474a"
    sha256 cellar: :any, catalina:       "9e714566437e60a45c978daeade8dbb3515ee37c5d2b6de1a203443f243917d8"
    sha256               x86_64_linux:   "8f5ca6b63b8fc347e8221765dc09ac1000f4b6a62e53424fb578bb14103c8952"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Don't statically link to libzip.
    inreplace "src/SConscript", "pkg-config --cflags --libs --static libzip", "pkg-config --cflags --libs libzip"
    system "scons"
    bin.install ["src/huexpress", "src/hucrc"]
  end

  test do
    assert_match(/Version #{version}$/, shell_output("#{bin}/huexpress -h", 1))
  end
end
