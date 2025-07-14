class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/main/dhall-lsp-server"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  stable do
    url "https://hackage.haskell.org/package/dhall-lsp-server-1.1.4/dhall-lsp-server-1.1.4.tar.gz"
    sha256 "4c7f056c8414f811edb14d26b0a7d3f3225762d0023965e474b5712ed18c9a6d"

    # Backport relaxed upper bounds for lsp dependencies
    patch :p2 do
      url "https://github.com/dhall-lang/dhall-haskell/commit/a621e1438df5865d966597e2e1b0bb37e8311447.patch?full_index=1"
      sha256 "89b768b642c0a891e5d0a33ac43c84f07f509c538cf2a035fad967ce6af074ef"
    end

    # Backport support for text 2.1.2 picked by GHC 9.10+
    patch :p2 do
      url "https://github.com/dhall-lang/dhall-haskell/commit/9f2d4d44be643229784bfc502ab49184ec82bc05.patch?full_index=1"
      sha256 "877ac62d2aa87d8aeb13e021b134298a299917f30b6a7a5962d5a06407c38067"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc15cc3642206d59076f34a82cb4280e2755d427065711763529f848a711c401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c3923f8db87be736d4ea429f0165383eba919facd3033ba3ffaa01e6607ec08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d24735c86a2713a7016cc94bece0ab9421470f4be47e7fede73217b43c18d27"
    sha256 cellar: :any_skip_relocation, sonoma:        "2978096a8175e81e0b89b4b55b3de417206850c0abbe14ca869c13faf916df34"
    sha256 cellar: :any_skip_relocation, ventura:       "1bd665c5789efa9e61e36859dd4381663b05913c38c9d5e8e98e34783d3e8db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "386e383923218adddb93e597da6ec639d81f3bb0033a7bf197a683c003762ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590cc648ccea52123ff837a8f00cf19983ac2672d1be0fe570bd7500bed6c2c2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = if build.head?
      # Skip trying to resolve constraints for packages that are not compatible with GHC 9.10
      # Remove after https://github.com/dhall-lang/dhall-haskell/pull/2637
      inreplace "cabal.project", %r{^\s*\./dhall-nix.*\n}, "", audit_result: false

      ["./#{name}"]
    else
      # Workaround until dhall-json has a new package release or metadata revision
      # https://github.com/dhall-lang/dhall-haskell/commit/28d346f00d12fa134b4c315974f76cc5557f1330
      # https://github.com/dhall-lang/dhall-haskell/commit/277d8b1b3637ba2ce125783cc1936dc9591e67a7
      ["--allow-newer=dhall-json:aeson,dhall-json:text", "--constraint=aeson<2.3"]
    end

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
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

    output = pipe_output(bin/"dhall-lsp-server", input, 0)

    assert_match(/^Content-Length: \d+/i, output)
    assert_match "dhall.server.lint", output
  end
end
