class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.15/dhall-lsp-server-1.0.15.tar.gz"
  sha256 "1eb7be9e55e522c9e8d7fe6c19f2dbdf7b51407f2549ff53f56d0bf1449a062f"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07f9af1351b40ae7cd1bdc5db61404392c9d7ba4ac766b8f9a92627cb4d4df5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbabac4f3843647e10c6033782bea557262d4aec6496e8060d0efdcd09fc9050"
    sha256 cellar: :any_skip_relocation, catalina:      "ab053b0c60d4b8dc295aef32539bfc0118d51c77a6ea658c718719f074314598"
    sha256 cellar: :any_skip_relocation, mojave:        "96bea66ac46d38db419c5be06ac060f0df3fd0e9a31394353fe379537e21c65a"
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
