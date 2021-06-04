class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.14/dhall-lsp-server-1.0.14.tar.gz"
  sha256 "4962f3b272a9fd4ce36c509094a391394167ec2cb08802ec8680994c0707c8cb"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4e52b159845ab3d3f0c38b1513925dc71229384f1fbd2e1f3af93fb95a5a547c"
    sha256 cellar: :any_skip_relocation, catalina: "c90bfdc825ded77c2d78f7cc348c34ce9085c2133921be93badc461cd838ff3e"
    sha256 cellar: :any_skip_relocation, mojave:   "6a75796367fa4e48806035d13b1b4403ed31ad592e7df7992b9cb959c8b27011"
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
