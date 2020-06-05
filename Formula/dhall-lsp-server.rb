class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server"
  url "https://hackage.haskell.org/package/dhall-lsp-server-1.0.7/dhall-lsp-server-1.0.7.tar.gz"
  sha256 "81b85964ef2865b76fdfa494e241090da3dbd00fac3b2f1b530ee9e35354de22"
  head "https://github.com/dhall-lang/dhall-haskell.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "946e9974f168ecd5920186d292ab082b016962b6dd4c5ba66923f400578993a1" => :catalina
    sha256 "9a7603b9fecac5f0e181b39d7d39249a3b2b3cfd94d051666c4e46f8a6483d63" => :mojave
    sha256 "caf41d83c2c4626e8bf3ba818c75d5a525b2fdfe89c419cf49044cd7ea4bd834" => :high_sierra
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
