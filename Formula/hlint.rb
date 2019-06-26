require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.2/hlint-2.2.tar.gz"
  sha256 "9d8a6379901997a60cd6fc598b12a7d5ec889196b0958eaeaeddca6b19d14124"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "59e405c3cddfbbb6e72d0d29e183e4508423e1201d6d5e51cbdfa30c16c0a0c8" => :mojave
    sha256 "fde5bd31523941a0b8746dad8b4aa0defae0e415986b9ee7ed660d681bdcb740" => :high_sierra
    sha256 "f4bcead30b942b867c0eecdd65344d41f7882c12c72a683afba3a5a405d520a2" => :sierra
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
