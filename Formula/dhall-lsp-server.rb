class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.18/dhall-lsp-server-1.0.18.tar.gz"
  sha256 "f27a3132ca04eaff5901cb2d184308b595b6bf7c58b60b4af37aae8509eb8cba"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c98af6ae9b4de7de16d8885d02b01df7cbb0fd893cfa6f0aa530fb3de43895e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb037edd880f19253448ed5f5cb6626b51c5c8fe700e6c8e9b924b74f18c3e17"
    sha256 cellar: :any_skip_relocation, monterey:       "43dd0703dfb01a42a0cdd1fdec984d990cf537b587c9c3aaf5ff194f0c8eb464"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d8600270f31b7b219a06af0e339ca7962f5da71d7e01399781dc637c14f4611"
    sha256 cellar: :any_skip_relocation, catalina:       "4afc9ba32363e1cc6e5c14b1bd745206cc46b897937c4dd75b96642c30e90aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e4b82c321e6c7a266aae0173067d3925438c917e96a534046ef7f867e32f667"
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
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/dhall-lsp-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
    assert_match "dhall.server.lint", output
  end
end
