class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-6.0.tar.gz"
  sha256 "3f54d3b917d71a233d49078a6c1d3a1197ebc2ae7a19d39d0c8d7141636f24dc"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    sha256 "8d500845a553dafeffbc2ac3a34d15d05f84e39707141ad6eddf30dd68b80c8a" => :sierra
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
