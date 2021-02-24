class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.13/dhall-lsp-server-1.0.13.tar.gz"
  sha256 "530587160dc993e820c5be0eadb55d703f2510b29efcf59b3d1cdc5b5b0f4532"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "7c9f9d9f40fdca93c74c702d4d0ec4562dba40b108c23a199dbc421b8a0c7010"
    sha256 cellar: :any_skip_relocation, catalina: "796f9f64bca695133ac77808829b3061d440a8f553d088aebcf43722faa97d61"
    sha256 cellar: :any_skip_relocation, mojave:   "2315da10f4c2901f23639342719cedff401c42de3c5c07fed0030ecc6675443d"
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
