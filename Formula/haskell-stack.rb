require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.0.4.3.tar.gz"
  sha256 "30dbf61cb8660ab52602c37bf41c31522af30609408d5ae0c20f6edbdb021ce8"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "b47df308dbc37fdcb63eabc6ac537420e14c6947044e12b8b241dfc197c432ab" => :el_capitan
    sha256 "adc6ee1d2a24133158bc84731c4b0ed7ea9836c1977eda2427fba898949340cb" => :yosemite
    sha256 "ea59f2157bedc35aad6b42503cb701d3523fe64268e32bb231cec448315f2e60" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
