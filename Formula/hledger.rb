require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.14.2/hledger-1.14.2.tar.gz"
  sha256 "849a6e0683192ec504da9a631ddfc82e04973583f4a028fd39b8cdac2efe29ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "45fd71a04aaa1e26fd86608f4c490d946f29238d9053c2019b2d502de0f225da" => :mojave
    sha256 "64b3460aabd792a4d0a74991187591774bcee3086074abb72aef39607f144c83" => :high_sierra
    sha256 "602fa95affba0309c55eeb4e7b66a5c65c025f3d113f10360a022dd07ae68496" => :sierra
  end
  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  resource "hledger_web" do
    url "https://hackage.haskell.org/package/hledger-web-1.14.1/hledger-web-1.14.1.tar.gz"
    sha256 "a1eacde5b9d531df0875b65c8239e8351749610e1e6e46c847dd02594fb6a970"
  end

  resource "hledger_ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.14.2/hledger-ui-1.14.2.tar.gz"
    sha256 "9951a8665c7a182d8008c92565272a6c4a8e12d363df4b169fa09dddffee112e"
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
