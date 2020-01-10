require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.6/hlint-2.2.6.tar.gz"
  sha256 "c1de3d22bf4f358cbc1fd8e15d9e5960a0827119c48d212053612196bac58324"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "bf98054f0474adff7b1ec27ec79c7fb447abbc836fda61f247222a783efe8683" => :catalina
    sha256 "681fdc0f297e16767a1dcd3e7806f40062952230e399753bbf53f6b86b09a437" => :mojave
    sha256 "c5f484328a9f5a775bb345a9ed32a9eb8c0e2ca875631ddf465ae90ab830f91c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
