class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "4dcb0908192993e654fd7d91234ed375bc15b873c1edc9e4a99e67404488bedb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b1e607bd11edb01ab0eeeaeb6638881f660b2dd659d2c67a179ede367501990"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d91619260a7ebb660e1b2d35eebaba14edf6d011dedb81edf4ffdbc272de6f7"
    sha256 cellar: :any_skip_relocation, monterey:       "2fab6e6f5790dce81827737ade35a87b88ef1d648192f2a039493bbaebddbb79"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b149c02dfe6a95e45df585af742232270ad0a5fad4053c5066ec1abca992028"
    sha256 cellar: :any_skip_relocation, catalina:       "d58a307d9178e24113e73b30aa8be491a48fbc9290f2baf7cb595cdfed0b22fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a7a6a04572683a82ac25c8c5e12b22c9e7559d908a250a9b2929e866fb6d57f"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release", "-o", libexec

    bin.install_symlink libexec/"language_server.sh" => "elixir-ls"
  end

  test do
    assert_predicate bin/"elixir-ls", :exist?
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/elixir-ls", input, 0)
    assert_match "Content-Length", output
  end
end
