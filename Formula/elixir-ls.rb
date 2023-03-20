class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "cabfa1af4e95c7760c4caee390432bdc067fd7c237f7d6f77a19caf6c990a242"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6b35a51c6198747f576f107cc0df727f483199ffbc3cbfff5dc6a27e832a415"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a18074ef545d92de85e63c5d7a4bb42252529564201a594064e11dce77a954b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "355685d7132e77bae6bb591d510c21f584b4e62c8543261973549d8d5fc21182"
    sha256 cellar: :any_skip_relocation, ventura:        "88319f6ecd50b1657e0830e84cced36eb27e5c0d38d9fb61410ce3997660e8ac"
    sha256 cellar: :any_skip_relocation, monterey:       "86aa8298d0643a6e06bb5e3c39c64ca19b61e716ee022ab08f4285328373ba75"
    sha256 cellar: :any_skip_relocation, big_sur:        "42738b3f7b1309a4dfe4d697c32a3211d650dc5f2947f0ba64782a51923a2e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6e8585693628a9b86a4f4de00734c7c0db5b09f9544a92b98f45cc6202d1a9b"
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
