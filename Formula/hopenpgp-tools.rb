require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools/hopenpgp-tools-0.19.4.tar.gz"
  sha256 "e656cd989833c6d318d5c44931ef5a8cd98bb0ebb4bab70a2d2f701091d0abd8"
  head "https://anonscm.debian.org/git/users/clint/hopenpgp-tools.git"

  bottle do
    sha256 "eff4e0ca14ca088a780c058c0f205ecd487915abece7679e91f5dea2ea5ee807" => :sierra
    sha256 "71f1dad3a01f39cb4349ecf19956b41edd837fcde61fbb4627be87cfa977d419" => :el_capitan
    sha256 "f0248da438ef0e4a2ad9dd16246b863a5cdd9bda1d280261ccc1a6e2683f42f0" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
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
