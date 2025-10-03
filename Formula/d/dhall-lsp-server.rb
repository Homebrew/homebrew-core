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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "797c7aaf9dfa0b1f3ac0fa6f9e60f65104f6e00f32c6e2d8a6ff61bef59cbb26"
    sha256 cellar: :any,                 arm64_sequoia: "c1360370c18b3dd49045a151702e1c47e682061b038da2b8c5c01a4f02061dfb"
    sha256 cellar: :any,                 arm64_sonoma:  "a80e624b671d0a14d92dbc998596e547c0923d35aaabc1f1a6987182c37396b2"
    sha256 cellar: :any,                 arm64_ventura: "246f4f56e4f00e9f21099d476dbc39373678f839f0b0b15cf1ee78a46c42a3d8"
    sha256 cellar: :any,                 sonoma:        "80c56c36b6e2c24a5856531f008de9483a2c9f57ca97eb21fd0abaa8d03a8806"
    sha256 cellar: :any,                 ventura:       "3de7a46b8262e74062f3dd8899620eec6d289b6926b09b61842fbafbc0878acc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b45dc4e064626430772b0e482bd439af404e018edf3f07b06fa85c4fc0efa04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7f98063d0d1fd03f9da8bf1b320f4263e756b0bd871f3fd45f85cd8d24c886"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
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
