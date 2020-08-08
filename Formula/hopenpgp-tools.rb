class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.1/hopenpgp-tools-0.23.1.tar.gz"
  sha256 "b28ac66343a0bf78b3bfb22cc87f85355909fcd49d9ba5ad43e5a0c38e8b014b"
  revision 2
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d03ebe24464c62fae11b856eb20f9b1ea4d67470ac65b8f770b20cf5f319913" => :catalina
    sha256 "4e4744a3d82755df2e2d03c775f99414faa5d13cdc1efa2462b16d65db1561e1" => :mojave
    sha256 "a2184881695b6d7209c40467a5c57c5ce32b1604fa909df13c84b3ed1aab3408" => :high_sierra
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
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
