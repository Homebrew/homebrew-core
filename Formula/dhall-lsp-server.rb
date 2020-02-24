require "language/haskell"

class DhallLspServer < Formula
  include Language::Haskell::Cabal

  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.5/dhall-lsp-server-1.0.5.tar.gz"
  sha256 "e8da592d106b3b9360d8e957a704297d501ac16cc34e7dd38e28fe77f3033dd3"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e26b047eef60fc030b681aa93feb361720fd6f7f3888568bd19e800005fcc3e" => :catalina
    sha256 "725f29f585ae622215cdf67c829f0a845fe1d507768ebbece4b74799d8145a1f" => :mojave
    sha256 "56ea1fa1ee54c1ea248ca6083d448fcf1e6ab56b3e305350166a9619c27c0e6e" => :high_sierra
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
