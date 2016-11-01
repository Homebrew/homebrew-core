require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.0.1/hledger-1.0.1.tar.gz"
  sha256 "835de42bebfbf55a53714c24ea4df31b625ee12f0766aa83aa552ba6c39b7104"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdb098173abbf4a05a7534c16af1f06ae386098f3f701e8ea955441b585f7497" => :sierra
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
