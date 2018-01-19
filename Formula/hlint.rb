require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.0.15/hlint-2.0.15.tar.gz"
  sha256 "4de8df4a3fc46f7f3708f8b24acd286a310b36379a2866e5e419619d644b3e4d"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "3adf9d9731c14c6910bd8509fae2921593aaa2dfc52bfd6cc274dc7362f293eb" => :high_sierra
    sha256 "8b99e07fb3271b3b29e0d54b87ea53bccdba87976638b59a778ae2e6732c2a59" => :sierra
    sha256 "c72bff8ec916975cf7b69e24cfe2863dca60f185d439d31d4051617770b791f4" => :el_capitan
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
