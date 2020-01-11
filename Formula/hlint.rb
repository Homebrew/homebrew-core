require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2.7/hlint-2.2.7.tar.gz"
  sha256 "bd6248ac5f704c17800c7d5227eddcffd570c08522d0d8a4b066108010bf9861"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "bfb2f24d1dbac150416174f62777bce248815c7a802046144fcc4c6ef43a37a7" => :catalina
    sha256 "36ddda3f951ded376a37e1d2aa1f09bd92a6d30010a2b25262eef4fc5379d539" => :mojave
    sha256 "f5b3aa71b11d1b78dc8e5e18412e92e4a3f5a5cc1e1969138062667e7e0e7037" => :high_sierra
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
