require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.21/hlint-2.1.21.tar.gz"
  sha256 "447209a1781a65ec2a4502e04f7a3eb1979fc4100b32d7124986c7326fb688c6"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "51271d5f8c6970ab6f440b32f84e47203c701e0fec926c0455f4a14e95acca5f" => :mojave
    sha256 "18a4dc93879b8e0537717aef489e118df0fc8f8ba0edfd0741c65d0ed212aeac" => :high_sierra
    sha256 "f1d8ac5bb734566c7df6f2d7dc4f595d87d0e613018160a3a811d27904e9750c" => :sierra
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
