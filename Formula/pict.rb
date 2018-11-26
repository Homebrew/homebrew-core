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
    system "curl", "https://gist.githubusercontent.com/glsorre/9f67891c69c21cbf477c6cedff8ee910/raw/84ec65cf37e0a8df5428c6c607dbf397c2297e06/pict.txt", "-o", "prova.txt"
    output = `#{bin}/pict prova.txt`
    output = output.split("\n")
    assert_equal output[0], "LANGUAGES\tCURRIENCIES"
    assert_equal output[4], "en_US\tGBP"
  end
end
