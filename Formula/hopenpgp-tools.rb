require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools/hopenpgp-tools-0.19.3.tar.gz"
  sha256 "4f1b7ce4fa6f1efa39fd0388204d24d82b9293e8cf1087b2790013a350bbd26f"
  head "https://anonscm.debian.org/git/users/clint/hopenpgp-tools.git"

  bottle do
    sha256 "c9ecd2a57bf4a4156f79605bff5700615d31d92ad074886da9602d057c6ea53b" => :el_capitan
    sha256 "505cf0e09cf05126df500f710a26ae3621e6eb859d24e57b159a2a9355945978" => :yosemite
    sha256 "74bd12518b9f9d549b4fe2bf49206dfb797f1bcdfd28c8a6684e3c8f659d6cdf" => :mavericks
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
