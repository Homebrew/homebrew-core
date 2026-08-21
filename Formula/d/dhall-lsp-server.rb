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
      type :backport
    end

    # Backport support for text 2.1.2 picked by GHC 9.10+
    patch :p2 do
      url "https://github.com/dhall-lang/dhall-haskell/commit/9f2d4d44be643229784bfc502ab49184ec82bc05.patch?full_index=1"
      sha256 "877ac62d2aa87d8aeb13e021b134298a299917f30b6a7a5962d5a06407c38067"
      type :backport
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "a6daaa49d5c98125647b3cde6f70c733acbf19d244a67d3a3b8b664ec17e57c3"
    sha256 cellar: :any, arm64_sequoia: "aab22a2fee405b6ec9218b9d82c303fa382456fc4e40c057f7ae10568f246492"
    sha256 cellar: :any, arm64_sonoma:  "1057143024d6abf1c4ee0200824502cb01ccfad21fcf3d82c5eb80ca515f958a"
    sha256 cellar: :any, sonoma:        "91d18c95a5784d68c1e142260dfd3567a1d265e7a630d5fd38dc2e7bc13fa596"
    sha256 cellar: :any, arm64_linux:   "2850717581a83df04f78fd41249a77cdc12cb3df735ebdebaca53d0ab3bb72ef"
    sha256 cellar: :any, x86_64_linux:  "4f3ae9995258d100e40afd58c269aa5779f6b38a13ba3646f4129a5a873854b7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args << "--allow-newer=base,containers,template-haskell"

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
