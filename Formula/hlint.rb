require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.4/hlint-2.1.4.tar.gz"
  sha256 "906ef36ff7c6ec1306c6587b23c345c76f67658c4db896fa0f6334fd24b50f07"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "ed5128eeba0b714e6274f298f6373c534b0d792e485437cd730a70041a0fcaa4" => :high_sierra
    sha256 "bd1d62e81571f152b5af16f3b44545d93c84a1d802cc346d21ec204cc335b0ad" => :sierra
    sha256 "2323569161ad97afa4ca03bfefc15c2651324450d1cc6cef4ea455515df9018f" => :el_capitan
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
