class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-5.01.tar.gz"
  sha256 "ba2b93b3a83917f6084ab88d75b4848ce9354584fb36d70537fa7490e42921bc"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    sha256 "7c0b8ef336f9d2bac14e11f0ca838620428376ba4b1f29b6ac3614d3a5f61774" => :el_capitan
    sha256 "d10617714d882cce0a4a8754c03fe7f9df7adf01de8b0016cceafe092e98c163" => :yosemite
    sha256 "92ef32e3fff775db370d3c83ee1b09c0d3c7debab448be37f30465094b17f028" => :mavericks
  end

  def install
    system "make"
    bin.install "depqbf"
    lib.install "libqdpll.a", "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
