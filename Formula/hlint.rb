require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.2/hlint-2.1.2.tar.gz"
  sha256 "c23d77f8c33e8bb33d21bbc042e04dac0fdfa1d18ca48c3c9deaeca640eaa52a"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "a5f2aba78ae640f3e78b7aaab7820dc0050323ca8d42c19ecf31851592f75487" => :high_sierra
    sha256 "dfabda3fe0dd5a46451f82fa8f2fac43192c582e2182384cc54ad9c9793cdd3f" => :sierra
    sha256 "f5ee47f18b23134359b895106211984e19b97bad9cf177367b0b5b154eaba0fb" => :el_capitan
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
