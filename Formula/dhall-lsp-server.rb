class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.16/dhall-lsp-server-1.0.16.tar.gz"
  sha256 "78b2cfd45a6c3a9489d03719f3af230c8fbc4055d96b62e80951912bd79e4413"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e2124c41514651a7eb1da835e35957ab9aee3958341361f92f9bc258fef064"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "040c4961a15ce28cbfb896a0057b26d5b6ad155df4543d9efc9edcf518343aa1"
    sha256 cellar: :any_skip_relocation, monterey:       "198b8fc3aaf6a535057e52c075bc3269d60cdf8dfd83276d24f04b4db8875dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fd9acfed2ce6997a2a16435372b7d012a67fcb427a031cf24595c153d13c63a"
    sha256 cellar: :any_skip_relocation, catalina:       "2ef242fd1a6d231fcfa4cb37df3e58004da2d8e1a98452b0e5e82e3708f424bf"
    sha256 cellar: :any_skip_relocation, mojave:         "b8d9503c6462a3e0739001212ae5bebaf80d653df9de6b10f788f3f1eb623115"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/dhall-lsp-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
    assert_match "dhall.server.lint", output
  end
end
