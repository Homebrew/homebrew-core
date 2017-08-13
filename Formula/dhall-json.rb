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
    sha256 "697b6d1e15331009b0335a8cec67d966e4b95efd45ce922a19c9f1a050f6a91d" => :sierra
    sha256 "6d486562f91fa4840e723f5a206377c47a4bec16e4145316ca825017af541065" => :el_capitan
    sha256 "ea558afbe5d480f509251d17af204cf708909a488bcdf05cccd70f55b1ccc360" => :yosemite
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
