class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/master.zip"
  version "33"
  sha256 "73d36bc93d72dfbc936e11774c5615b23689cab1a3507995dcb9266d406f5e11"

  def install
    system "make"
    bin.mkpath
    bin.install "pict"
  end

  test do
    system "#{bin}/pict"
  end
end
