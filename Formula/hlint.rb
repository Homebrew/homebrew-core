require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.3/hlint-2.2.3.tar.gz"
  sha256 "e6df9f402a02011100248ffd4b9a5aa4bb5fbf7bb61677c50a0cdf5ac298b32a"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "641b47cdbabb274249e13ae1cf696e212d27ab9586713fdbb8267da512d50833" => :catalina
    sha256 "b61782e0026194a598071a725a04b602a78bdfcd4855c041b2ae88d088369a1b" => :mojave
    sha256 "bd15904aa4ce157c2218de16b4093d9554cf105f3e7a5a95784d050a2c1403f6" => :high_sierra
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
