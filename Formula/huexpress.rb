class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.4.tar.gz"
  sha256 "76589f02d1640fc5063d48a47f017077c6b7557431221defe9e38679d86d4db8"
  license "GPL-2.0"
  revision 1
  head "https://github.com/kallisti5/huexpress.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2305939ce9b39eb229e0ce01ad26a777411639c1fc5893298e3fa590fe3c7728" => :big_sur
    sha256 "7aa4fc9db666d6682f0bead431fd814310b04db7d3cfbe303577cc6a1d5904d5" => :arm64_big_sur
    sha256 "a17fe6ae136f94e859edbe7d65fc15466645c1d569fdbf363c841ec85477fa1d" => :catalina
    sha256 "f395a18b662d16c84b18e4594f67516a43e7a692879d68289c08ee652cedc651" => :mojave
    sha256 "53eec3fc474a553bdd70ad1c8dcb63714db5d059839748dcbc80b86380c81d4c" => :high_sierra
    sha256 "31ffed8cb0c04131abefe50aa06aa8154e3cf8e49fa24ebe5f4e6d456f6b3d9b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "scons"
    bin.install ["src/huexpress", "src/hucrc"]
  end

  test do
    assert_match /Version #{version}$/, shell_output("#{bin}/huexpress -h", 1)
  end
end
