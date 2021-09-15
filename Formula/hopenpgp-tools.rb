class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.6/hopenpgp-tools-0.23.6.tar.gz"
  sha256 "3df2f26a8e1c2be92c54b1b347474464a23d213a7982dd4afb8c88c6b6325042"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17ba6c71d6b2c1841bb4ea381a128e8a9cb590a751214a15b646602eab496e10"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6bbc4e108cb054f5723c0196bfffbef88ccd30242f01ea223525ed30efd83a9"
    sha256 cellar: :any_skip_relocation, catalina:      "11ee2dc0b5f625cef483385dea031640b8762367281f7382989d999ac4719655"
    sha256 cellar: :any_skip_relocation, mojave:        "0bd4820b9761e5e89d6751ade75a1d2ff6d7b192b71189294a78fe7f8215d95b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25189440b68e211dcb2ab3cd04349a761e461462e21691305b6c0217e6984f96"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  uses_from_macos "zlib"

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
