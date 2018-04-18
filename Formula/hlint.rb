require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.3/hlint-2.1.3.tar.gz"
  sha256 "6abc547c380937af2bb51570425c7edf6402ee051d6e1a6f4417d44d125a2722"
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
