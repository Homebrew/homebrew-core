require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.1.2.tar.gz"
  sha256 "8f43d69a00a8861b156705a634e55179524cefbd98e6c29182e7bdcb57d8b3be"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "648a91a315843c34ff42aac347e368b66df1689c3a7439ab36e5c369259e4a86" => :el_capitan
    sha256 "5fa124ca2ca69a8ebf08312d663e1da9649ba9ab9d2810c844da809615a65e68" => :yosemite
    sha256 "267a9daf5ffc8da11ff45484339f1fa286a516af55110e17be3e8c5a0b71bac9" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # GHC 8 compat
    # Fixes cabal: Could not resolve dependencies
    # Reported 25 May 2016: https://github.com/commercialhaskell/stack/issues/2192
    (buildpath/"cabal.config").write("allow-newer: base,transformers\n")

    install_cabal_package
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
