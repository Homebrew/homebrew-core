class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.4.2.439.tar.xz"
  version "1.4.2"
  sha256 "bdbcf99307baef3e76d99700691ac525c9a9cf96d8433b45c89314940cc6a1e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "53f12d55b4101fb0b3d5e30dacd0a8dfce6dc7ae1c8bd7bda8f49396d8c789e5" => :sierra
    sha256 "104cd675fc257344c5c96209a8cc924f50cf1bc4696f966e10e61ebeb4e2f62c" => :el_capitan
    sha256 "56540697be3d92f196343199911fc2a780fb4f554bd6542818659158081aaa43" => :yosemite
    sha256 "24362ba75c2e644c1480ba2e73536fdf3010e1f76b6d0b3dbde54e396d95095f" => :mavericks
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end
end
