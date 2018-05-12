require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools/hopenpgp-tools-0.21.tar.gz"
  sha256 "c352c11d9a68aaec5d22cfcabcd3dec28bfb627c11410be051ecf191ed23484f"
  head "https://anonscm.debian.org/git/users/clint/hopenpgp-tools.git"

  bottle do
    cellar :any
    sha256 "9279dd18f73815ebf36a2fb730b10e394795892969a9282a49779c223828859c" => :high_sierra
    sha256 "86228ad6e121d664e761c4458a5436c714b7bac53e1cafc23f7d084030570751" => :sierra
    sha256 "dae07e2177b17e9a015f080c1f98463534e25d7b8ac6ed83b80949a6747c48ae" => :el_capitan
  end

  depends_on "ghc@8.2" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    # Reported 7 Oct 2017 "Old versions of graphviz have no constraint on fgl"
    # See https://github.com/haskell-infra/hackage-trustees/issues/114
    install_cabal_package "--constraint", "graphviz >= 2999.17.0.0", :using => ["alex", "happy"]
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
