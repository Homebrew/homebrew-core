require "language/haskell"

class DhallLspServer < Formula
  include Language::Haskell::Cabal

  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.7/dhall-lsp-server-1.0.7.tar.gz"
  sha256 "81b85964ef2865b76fdfa494e241090da3dbd00fac3b2f1b530ee9e35354de22"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dec3c3ddfdbbf05614201c393fc7ff437ab80d6fd7ffe9a44e306c42238a99ac" => :catalina
    sha256 "099d52d4a2a52aa8a3f07d4e97ac194d4dcbfff6f8d7bf00d132e5539a4ea2df" => :mojave
    sha256 "0ac7cbbbe9b7ec82d848fb25ad3f7b83769ab76331c0e3206f27c217b3c2d4a8" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

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
