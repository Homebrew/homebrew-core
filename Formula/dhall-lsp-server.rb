class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.17/dhall-lsp-server-1.0.17.tar.gz"
  sha256 "88433b4334d75c625d76b61859359b31e173531f11bb858ea4776eed46949c40"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2db9ffeec60593d9c34d32bdbb09cb9dab790ab7b8191a5eac77570a7551cb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3caf64dcaba5d571112de9132bb2817f677385e401aef8c5a13d30165b4f16df"
    sha256 cellar: :any_skip_relocation, monterey:       "362a4b236a99238db361fc279af5a0a33cbfe6dab34490de42140780554a575a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b25a3d228420a8ca66dc2990dfae8880b6c97f54a1ce7a56214dfff99299e38f"
    sha256 cellar: :any_skip_relocation, catalina:       "67e5aeb8f75d83eaaa3615ba7e4e8636f5deb2bffba7b6231a30908d6ed1a0be"
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
