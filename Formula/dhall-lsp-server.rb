require "language/haskell"

class DhallLspServer < Formula
  include Language::Haskell::Cabal

  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.2/dhall-lsp-server-1.0.2.tar.gz"
  sha256 "dbda7d6ee8a670c3404837824878c8163d26ade64e0e228fd0be31e21fb3b3e0"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  patch :p2 do
    url "https://github.com/dhall-lang/dhall-haskell/commit/5ceb8d9d601421643f625670cb202057c274bc1f.patch?full_index=1"
    sha256 "0f169fb66f0fbba4b23a9f88806c6d161a38f238f572b2497f09713823cab8a2"
  end

  def install
    install_cabal_package
  end

  test do
    input = "Content-Length: 152\r\n\r\n{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"verbose\",\"workspaceFolders\":null}}\r\n"

    output = "Content-Length: 496\r\n\r\n{\"result\":{\"capabilities\":{\"textDocumentSync\":{\"openClose\":true,\"change\":2,\"willSave\":false,\"willSaveWaitUntil\":false,\"save\":{\"includeText\":false}},\"workspace\":{},\"executeCommandProvider\":{\"commands\":[\"dhall.server.lint\",\"dhall.server.annotateLet\",\"dhall.server.freezeImport\",\"dhall.server.freezeAllImports\"]},\"hoverProvider\":true,\"completionProvider\":{\"triggerCharacters\":[\":\",\".\",\"/\"]},\"documentLinkProvider\":{\"resolveProvider\":false},\"documentFormattingProvider\":true}},\"jsonrpc\":\"2.0\",\"id\":1}"

    assert_match output, pipe_output("#{bin}/dhall-lsp-server", input, 0)
  end
end
