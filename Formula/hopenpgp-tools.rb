require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools/hopenpgp-tools-0.19.3.tar.gz"
  sha256 "4f1b7ce4fa6f1efa39fd0388204d24d82b9293e8cf1087b2790013a350bbd26f"
  head "https://anonscm.debian.org/git/users/clint/hopenpgp-tools.git"

  bottle do
    sha256 "4792c7efbf889bc1bd0320eb676c00b308226fca00dc04b6d61c97fa08e18271" => :el_capitan
    sha256 "40447318e21f020af89fd7e42390052295d4d5cd4bcbf269d9d1bf3c01edf361" => :yosemite
    sha256 "719d72366d7a6eb5ead4db7bab3e38af72ab65b6690a2f5a68dc6344d2a69b53" => :mavericks
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
    ENV["TERM"] = "dumb"
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
