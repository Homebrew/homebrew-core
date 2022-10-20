class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.1.2/dhall-lsp-server-1.1.2.tar.gz"
  sha256 "f013992d7dfd8f40d149737d04a8772308014ccc5d52c27d72dc1c1185882bf3"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b72ed07724e2a92a852dea0e273b97a63bc692488c5ed7ce0bb2efec4cab0ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c53f6489869ca6ffdc02b9d40145984b774f03b8673bb6c45df20d3e4008cf06"
    sha256 cellar: :any_skip_relocation, monterey:       "92ff21362d7b3daee2fbbce6b7737b7d50f797bc94f9cdbdc538cf3873e7afb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "46c142ac36a95e268ff69e3005c80e5030ae5b61845ff20cb16f347f824e3bf8"
    sha256 cellar: :any_skip_relocation, catalina:       "fb38e31c566cade3020e4b6ec3af2c050f79b99a9888452ef39495704326f84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efca8ee9de111302481c7dc9a862c68c62ccf435740d3607646fcaceb01e812"
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
