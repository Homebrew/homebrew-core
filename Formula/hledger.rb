require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.11.1/hledger-1.11.1.tar.gz"
  sha256 "e916a6c898f0dc16a8b0bae3b7872a57eea94faab2ca673a54e0355fb507c633"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "094e8f16f48d74d4681061acf2ae59d9908bb590b655a4cafaa179b75932813e" => :mojave
    sha256 "67d5ec47abd70d06d2e6effedeed024117befc3944acd6efa281bca3b9250666" => :high_sierra
    sha256 "0f2d3ab4a3ed38fcde4eba321b83e579273b39ca0cd8700a5e4c3a5d7e6d750d" => :sierra
  end
  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  resource "hledger_web" do
    url "https://hackage.haskell.org/package/hledger-web-1.11.1/hledger-web-1.11.1.tar.gz"
    sha256 "da9de30f06a6547240bfeb98a0de8f496df98619130a7dd8968f42f4678c70af"
  end

  resource "hledger_ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.11.1/hledger-ui-1.11.1.tar.gz"
    sha256 "924988e477b968ca6c17e57431614f6032c114265a7d3ab03d4d4c2ff516660e"
  end

  resource "hledger_api" do
    url "https://hackage.haskell.org/package/hledger-api-1.11.1/hledger-api-1.11.1.tar.gz"
    sha256 "0cd34629e2ad4ebf140dea3c24ff401fe61bfda198f105eb228eb7159b964bf3"
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
