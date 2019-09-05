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
    sha256 "c47c79277b44e3155acf83f2e9bbceeeaac0ffdf1faa511bf2468cf73b2ca441" => :mojave
    sha256 "106a4ca34518a4a19695b96b5966c2016b8616a6c17e2d6d1413a4549840ca69" => :high_sierra
    sha256 "b5966fba039bc47a91f7dd0aaea238dffae0e6417e34dbc8fa5ac517211b4487" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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
