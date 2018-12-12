class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.1.tar.gz"
  sha256 "c0b6cb911a773abdd555e6a9e0eb8a25934ceca038156e6250e117fa451beaa6"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eaf5283b2eb0aa6b68a72b104fae60fef7e0f7c8e348151180733ad26518e02" => :mojave
    sha256 "a342d8fd89ec66985aa597e3d7776ca56c0327effeba64adc51e71c636101365" => :high_sierra
    sha256 "fd5025ee61910ff50ea057ec7de2d3cd32323583f274096a5f53dd91e97dc8cb" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
