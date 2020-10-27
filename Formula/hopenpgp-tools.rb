class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.1/hopenpgp-tools-0.23.1.tar.gz"
  sha256 "b28ac66343a0bf78b3bfb22cc87f85355909fcd49d9ba5ad43e5a0c38e8b014b"
  revision 2
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "399bf10f33cdbcefaee7a2afb513778b81f50b6620abdcd0901a9ad161a9f3cb" => :catalina
    sha256 "cf9bb6c229ac34360ea5d5f94776815615138f665c2eae730174065c721f0a6c" => :mojave
    sha256 "5d0056622d3843f49632d0ccb459cad19304b8fa2ed2c6328df1e14e0dec840c" => :high_sierra
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
