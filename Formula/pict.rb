class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.1.tar.gz"
  sha256 "4fc7939c708f9c8d6346430b3b90f122f2cc5e341f172f94eb711b1c48f2518a"

  def install
    system "make"
    bin.mkpath
    bin.install "pict"
  end

  test do
    system "test", "#{bin}/pict"
    system "test", "#{HOMEBREW_PREFIX}/bin/pict"
    output = `#{bin}/pict`
    output = output.split("\n")
    if output[0] == "Pairwise Independent Combinatorial Testing"
      return true
    else
      return false
    end
  end
end
