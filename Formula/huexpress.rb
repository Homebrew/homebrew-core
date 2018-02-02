class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.4.tar.gz"
  sha256 "76589f02d1640fc5063d48a47f017077c6b7557431221defe9e38679d86d4db8"
  revision 1
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    sha256 "12bb6a3dc3133a51d34673650c15f45403d94d4a2d26c25ba02f287a63147d96" => :high_sierra
    sha256 "7b56cecf8105dac9e68b50884c7ba86e7a02fdeb7e7a61c6c6c47b8085d15037" => :sierra
    sha256 "6c4e602c8d0239e47755604dbd0f4e4b8b9a0e061dca3c79824303980eecc7e4" => :el_capitan
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
