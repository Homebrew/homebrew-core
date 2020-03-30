require "language/haskell"

class DhallLspServer < Formula
  include Language::Haskell::Cabal

  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.6/dhall-lsp-server-1.0.6.tar.gz"
  sha256 "9b5a963daf3b7c0622ea519433b5046127bc945a8c90df9ec37cd9ae92fe7ddd"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef4b5e662f7a1febed2e336ed208e8b5271370dc648fe0ff7eb8d5deeb153ca6" => :catalina
    sha256 "83dfa0bb1ea1941c8ef3bb25c41470fa1fe6c4eba12258227428db73e8fb2d2b" => :mojave
    sha256 "3aca7e33e737a7b9f961d2039d066d9585bcbacaf8f9fea2eab5569572f3b3c4" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output =
      "Content-Length: 683\r\n" \
      "\r\n" \
      "{\"result\":{\"capabilities\":{\"typeDefinitionProvider\":false,\"fold" \
      "ingRangeProvider\":false,\"textDocumentSync\":{\"openClose\":true,\"ch" \
      "ange\":2,\"willSave\":false,\"willSaveWaitUntil\":false,\"save\":{\"in" \
      "cludeText\":false}},\"workspace\":{},\"implementationProvider\":false," \
      "\"executeCommandProvider\":{\"commands\":[\"dhall.server.lint\",\"dhal" \
      "l.server.annotateLet\",\"dhall.server.freezeImport\",\"dhall.server.fr" \
      "eezeAllImports\"]},\"renameProvider\":false,\"colorProvider\":false,\"" \
      "hoverProvider\":true,\"codeActionProvider\":false,\"completionProvider" \
      "\":{\"triggerCharacters\":[\":\",\".\",\"/\"],\"resolveProvider\":fals" \
      "e},\"documentLinkProvider\":{\"resolveProvider\":false},\"documentForm" \
      "attingProvider\":true}},\"jsonrpc\":\"2.0\",\"id\":1}"

    assert_match output, pipe_output("#{bin}/dhall-lsp-server", input, 0)
  end
end
