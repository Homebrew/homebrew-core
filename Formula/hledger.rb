require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.14.1/hledger-1.14.1.tar.gz"
  sha256 "5e5df9de8efa4133a543c4f47aeff2db1efb16ac77713572cac2da3b8fc2318d"

  bottle do
    cellar :any_skip_relocation
    sha256 "45fd71a04aaa1e26fd86608f4c490d946f29238d9053c2019b2d502de0f225da" => :mojave
    sha256 "64b3460aabd792a4d0a74991187591774bcee3086074abb72aef39607f144c83" => :high_sierra
    sha256 "602fa95affba0309c55eeb4e7b66a5c65c025f3d113f10360a022dd07ae68496" => :sierra
  end
  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  resource "hledger_web" do
    url "https://hackage.haskell.org/package/hledger-web-1.14/hledger-web-1.14.tar.gz"
    sha256 "eb10512a8dd6af6b046d65f2d1dfcdd37eb22e1040108e29212ab0ca0abc5295"
  end

  resource "hledger_ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.14/hledger-ui-1.14.tar.gz"
    sha256 "531ab28284370cc67316d409d41aef706eeb3d53a1d2c032f9147b5f095bdfde"
  end

  resource "hledger_api" do
    url "https://hackage.haskell.org/package/hledger-api-1.14/hledger-api-1.14.tar.gz"
    sha256 "ad7a714201cf912a6c756e40a25116e2352b86a81b048599c15f403b2a65f7a3"
  end

  def install
    install_cabal_package "hledger", "hledger-web", "hledger-ui", "hledger-api", :using => ["happy", "alex"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-web", "--version"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-api", "--version"
  end
end
