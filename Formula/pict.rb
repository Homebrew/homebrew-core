class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/b7409105e56dde75c38710aeef8ac51a3455a351.tar.gz"
  version "33"
  sha256 "b3b9c3a4581555bd20e345d08df9542e189fbe54f51d76628b1226705f0624b3"

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
