require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.3/hlint-2.2.3.tar.gz"
  sha256 "e6df9f402a02011100248ffd4b9a5aa4bb5fbf7bb61677c50a0cdf5ac298b32a"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "a1e444d105c5cd0dd5e702dcc491a7041e3425f987accc2d878ac3f05c6040fa" => :mojave
    sha256 "8c83f7ab9a17c11f4e4a3593401e01c347b00966abbcf1130d995102533432dd" => :high_sierra
    sha256 "e55d0462d86eb3e09e8cda93980afbc742954127bf1ef4310d7faefaaf3858af" => :sierra
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
