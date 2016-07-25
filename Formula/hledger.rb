require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-0.27.1/hledger-0.27.1.tar.gz"
  sha256 "f85b8d7ea7a2c7ef1ba1fa4645df951a7bf2f83e4117fdc34d9dacfa7d17376e"

  bottle do
    cellar :any_skip_relocation
    sha256 "902c3bccc2735fea965609d09399443b55d93f25e43d43f618295e0e1964f4df" => :el_capitan
    sha256 "9ee7e6741316b518f0981203e86db9324cb93ed2f686d1a875907aebfa7d46fb" => :yosemite
    sha256 "b408fb08725ff8fa70c00d11af345ad2511de32a046fbc378b1676b046d13be8" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/hledger", "test"
  end
end
