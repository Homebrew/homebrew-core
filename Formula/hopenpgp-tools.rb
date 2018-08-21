require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.21.2/hopenpgp-tools-0.21.2.tar.gz"
  sha256 "b418dfc81e9fb19216ffe31cdc74c78c054a049d1eb6c01f3a4acbe5c722068c"
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  bottle do
    cellar :any
    sha256 "3976c2e1b20371a75a3e1a4f592eb52ae368d2e36ba1d7578229eb6199d3f04a" => :mojave
    sha256 "fbff2a1c3fd29fae1479da5e67536d2e2bd7d47f787c56879f547d47c513dd67" => :high_sierra
    sha256 "69fba3dc2a07ad7c9f8b59cfaf4b5df8cf33a48420cb1e7fcaafe374b0e6c897" => :sierra
    sha256 "d3a4f24226d6b0c6ad6021b0f9a29c54c60b9e4b3e5c682f014d6ab8d77ce6fa" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
