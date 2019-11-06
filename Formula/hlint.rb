require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.4/hlint-2.2.4.tar.gz"
  sha256 "adfcd0c5ace702c6c78a3f7ef366ae0e92d9c8993019ddf4f59abbef631de000"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "dc4d887ff51db7ab108cc65c71b52c56743e3d0f53451abeb99c98b6a1587f07" => :catalina
    sha256 "8102a58f39753a9045a313c2fb87f36033612c5601cba77118aee1a4288cee88" => :mojave
    sha256 "95b1936ef40ac1b960030c162d66994d32a8e9ef09cf3d9ac45eb3fa0d718343" => :high_sierra
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
