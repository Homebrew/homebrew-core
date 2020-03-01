require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23/hopenpgp-tools-0.23.tar.gz"
  sha256 "5402d9fc177805383fbcd87727c12ef02997ab96b3b6f5e58509611d16eaf8e9"
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca547dd8864f4013ce6ae6d863576eed574da0f763762ee98ead3f477346a41c" => :mojave
    sha256 "6a56f27602476e83117b5359cdfe449e7a224b317d9283945d945ea7562fd074" => :high_sierra
    sha256 "51a39adc8c7d59e1c7d0032a827e9dd2c8055cb7e6b176cc7b679fb118503572" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    install_cabal_package :using => ["alex", "happy", "c2hs"]
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
