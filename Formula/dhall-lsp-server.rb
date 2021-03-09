class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.13/dhall-lsp-server-1.0.13.tar.gz"
  sha256 "530587160dc993e820c5be0eadb55d703f2510b29efcf59b3d1cdc5b5b0f4532"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "5527e7912597fa0f7a243e56abf4ca7d1314f11a7b3f3d20e657352aa92ddf17"
    sha256 cellar: :any_skip_relocation, catalina: "ddb16a6b5f23877ce240ed1fb00fced177c9d4839a5110acceda749723366da6"
    sha256 cellar: :any_skip_relocation, mojave:   "5d8295828215b009bdf19784fde2b79feb13bfbfc7831a1a41278c9ea07b0fd7"
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
