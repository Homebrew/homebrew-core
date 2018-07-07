require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.8/hlint-2.1.8.tar.gz"
  sha256 "9713ebf3d0ae16c169d0e02486ba93bfdc6349d9b82dccf8a19a58c1177e75ce"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "3b9d9cfe5f3a03697b7c897f275060804f34cbc929828d723b4ebe4f31410b0e" => :high_sierra
    sha256 "cb1b08f86498c00c0ffc28b86629f872e72b4d2979f47e1afd191ec28bd93d98" => :sierra
    sha256 "be9108264fe69cc7e2497a4b059bc2f417b681cf5ad4cb92858400a7fd92eaa6" => :el_capitan
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
