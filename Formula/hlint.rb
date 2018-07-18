require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.8/hlint-2.1.8.tar.gz"
  sha256 "9713ebf3d0ae16c169d0e02486ba93bfdc6349d9b82dccf8a19a58c1177e75ce"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "a48d46cdd3aaee9ed2ae2d0decc4f9a4ddfe3526095917eff61c010b7a1b545f" => :high_sierra
    sha256 "ccf6f37b1d44cc063bdc08b03cceaa6589c39266e54d406096661ddc48d8a368" => :sierra
    sha256 "2610f48e027a3a47e510920b5f55f1791009ff4e164b4a021aafd9113cefb3c4" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => "happy"
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
