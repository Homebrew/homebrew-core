require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.8.0/cryptol-2.8.0.tar.gz"
  sha256 "b061bf88de09de5034a3707960af01fbcc0425cdbff1085c50c00748df9910bb"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0aca3e2c29be5d4533e6114f0e7fd774173358f92d0f4e73903d0d536fb54160" => :mojave
    sha256 "04d3178e67b8836a720d82dc3b88d1c69366aae6f0e7abdb9a1155b7dc31c28c" => :high_sierra
    sha256 "3c3ffec1e47196b6c1767086fb9cc62e792546476cad5c6b92896eb45db13744" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build # 8.8 will be supported in the next release
  depends_on "z3"

  uses_from_macos "ncurses"

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
