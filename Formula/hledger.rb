require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  hledger_version = "1.11.1"
  hackage_base = "https://hackage.haskell.org/package"

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "#{hackage_base}/hledger-#{hledger_version}/hledger-#{hledger_version}.tar.gz"
  sha256 "e916a6c898f0dc16a8b0bae3b7872a57eea94faab2ca673a54e0355fb507c633"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  resource "hledger_web" do
    url "#{hackage_base}/hledger-web-#{hledger_version}/hledger-web-#{hledger_version}.tar.gz"
    sha256 "da9de30f06a6547240bfeb98a0de8f496df98619130a7dd8968f42f4678c70af"
  end

  resource "hledger_ui" do
    url "#{hackage_base}/hledger-ui-#{hledger_version}/hledger-ui-#{hledger_version}.tar.gz"
    sha256 "924988e477b968ca6c17e57431614f6032c114265a7d3ab03d4d4c2ff516660e"
  end

  resource "hledger_api" do
    url "#{hackage_base}/hledger-api-#{hledger_version}/hledger-api-#{hledger_version}.tar.gz"
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
