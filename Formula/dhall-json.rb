require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.5/dhall-json-1.0.5.tar.gz"
  sha256 "68124c6a22b4070386d127af43209ad10f38e54a74fae188157d102da03ac501"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e9f6d597896a5eaf633cf3a5e809bf070792fbec8794f1b3479e58c78424142" => :sierra
    sha256 "b6d99dae96d02ec2dd7f64eb0a98bcbe70328e1abe6896eb586b8853c84f9816" => :el_capitan
    sha256 "8785b0f6e7c4157022799c2adfc442eb0c489a4e597d20ebfc2ed8a3a339104e" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-json", "1", 0)
  end
end
