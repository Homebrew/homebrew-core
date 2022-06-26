class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.1.1/dhall-lsp-server-1.1.1.tar.gz"
  sha256 "86b22a14be0ebe016e29cfd3436e4f9776f8817dfd72a9966437fceb8e608f7c"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0f4ea3e8be02869efd5e7c3d65cc78476659274728d19790b4277f19601a889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "254c20597bcf229e9c3f92aa4abb6fdf6c0d9b268024a47347b0e2ba2d20ae4b"
    sha256 cellar: :any_skip_relocation, monterey:       "9cdf9f2fda43f9c2290a4da045fca890869e964c0249a86d8c454c24bc8b79f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d2a2e093b09194a111017115c7a20ea4a1afa8e65ce7ed8c156261be170c93a"
    sha256 cellar: :any_skip_relocation, catalina:       "edcc7c615dbd03df65bac75c0a3b8151587f5c66f58ded7359cc32172d2d9de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecfd00122dc807b26961f22555dc775e80bf6ff56039d9840d8d772ba773e722"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
      "bose\",\"workspaceFolders\":null}}\r\n" \
      "Content-Length: 46\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"shutdown\"}\r\n" \
      "Content-Length: 42\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"exit\"}\r\n"

    output = pipe_output("#{bin}/dhall-lsp-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
    assert_match "dhall.server.lint", output
  end
end
