class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.4.tar.gz"
  sha256 "76589f02d1640fc5063d48a47f017077c6b7557431221defe9e38679d86d4db8"
  revision 1
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    sha256 "82e99480094c372b83088649696ee110b20b1f71c11d08f45125c03a7de28a17" => :high_sierra
    sha256 "0f2ad080284a6cf9076293a4f1f7afa7ca6461f9cb215d618a56a8f9101c2a2e" => :sierra
    sha256 "61d7da52fc3ad3e4a83b57e81dc66233a211bd7a850008ac2c7c3226d75b7071" => :el_capitan
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
