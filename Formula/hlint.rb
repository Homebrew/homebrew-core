require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.1/hlint-2.1.1.tar.gz"
  sha256 "a4e547f26d1631630b7a95ccb5318448aabce0fa6185c5cb8b85a212da56ae56"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "2a05b893ea59c2b85dba938f9e57940e96976327a5a117e0c99758ac121a85f9" => :high_sierra
    sha256 "134a350b5c01298044b0a77dcaeee9dcaf52bcb96e0aa7540c8e04007b3b2157" => :sierra
    sha256 "22ebf96e19749b60cb7774769ff5d4967c0de046d651849dca4642032c2abdd3" => :el_capitan
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
