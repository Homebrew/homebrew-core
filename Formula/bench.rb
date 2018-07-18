require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.11/bench-1.0.11.tar.gz"
  sha256 "a84e6faa55e62b7cb9f7d28a1d1828298f1c37b24c2a16da86954a35534a3b97"

  bottle do
    cellar :any_skip_relocation
    sha256 "931052a19d8ecbe5c5c1c1f73e65f6c2f564b0e7f514881929b98cda8b560d79" => :high_sierra
    sha256 "8e5201e30630ef332fae731aab908afac30aa55f5ec749aa59375d939a36bab9" => :sierra
    sha256 "f47df459af025f03350bccd3027930cb55c55ae0fd09acb634af62ae7135b956" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match /time\s+[0-9.]+/, shell_output("#{bin}/bench pwd")
  end
end
