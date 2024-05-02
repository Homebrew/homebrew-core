class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.8/hopenpgp-tools-0.23.8.tar.gz"
  sha256 "158be5544d28fcb3989376b6aee700aa6eed8390ffb8d41146b0aeff09433401"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2594f0655586997352c9ee99763670060b8dce25c465991554336037c810b88a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1e03da071e9e02873068fcd3ef5bc01b12eb7661f5a4144ca8bcfd08f9be96c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6e3ec151bf0dcdd8763a1e38b15f46d8f631387365f938e8e5a944605c25e86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dcb691db29afcb3c1230189085d41daad9f13e9d32dc0950daf18c102558e5b"
    sha256 cellar: :any,                 sonoma:         "f913b18d2bf982b65591a1b9b0c4e721f23c863b85d5dae28214490738bb12b6"
    sha256 cellar: :any_skip_relocation, ventura:        "8370937e307f6fe9abf7465cc83db8598598b05dfb65e327b0fc4679c03bfae8"
    sha256 cellar: :any_skip_relocation, monterey:       "be3d61452b9b26924c2286162e7b013f7111ece5a2c59e7696dbf4877f33d039"
    sha256 cellar: :any_skip_relocation, big_sur:        "e577fed1816884cb7fa00040b84f255ad3eb7f852ddbe4a1816506640b8d5a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5df863ac90d97fee229b7ef72eb22eae55841bd788f3d530d0aaa78ff1ebef5e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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
