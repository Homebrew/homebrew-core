class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "d90b3b8506678ae7e63d99c82b61987b58d178358c6b6a794be31d8ac5cb1829"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d1fd8c983a047fca29546a7725f092fdabaeabaf542628f5f48c62b68d0c7e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcb844ed781cf4b71ac8524f8993a4e0dcbf4eeedc2c29ae9c9bb28d7bea3060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edfddee1cd52646faa7ca534c8fc05e401a513a6a8ec3a626630065789c2f4c1"
    sha256 cellar: :any_skip_relocation, ventura:        "6560cf7ba71aba8da81f19fe95b6041b234b7f54f7d6d425526f282f36554045"
    sha256 cellar: :any_skip_relocation, monterey:       "6b519b4a35f590ef8a67067f29e90151a6be241136bb2f1e560219becc65870f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e63f328956c2c230df0b01cfa513b62ffc93a44606ae1a2f92f1a96892d9518b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8630fd5a54ebe49c3a5df42c576dc919b80729b493db374bcbdfd104f3e7b8f"
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
    system "mix", "local.hex", "--force"

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
