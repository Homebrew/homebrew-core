class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "http://fatsort.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.3.365.tar.gz"
  sha256 "77acc374b189e80e3d75d3508f3c0ca559f8030f1c220f7cfde719a4adb03f3d"

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
