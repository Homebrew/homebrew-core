class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "06531d9a61320c54ad75153c59563444371d53cde5bc318b22e28b0e1bbdfab7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d870dad81d7867a72a9c6f175cdf88e237223ba7622c8b969c5d0e024a0b8868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97fc99e8ff424f24ce1ab3390e8b710f36eb72c305903083bf3ea3b13fed88d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b0decd9808f465821bd1bc7d9483a39716509805d22410d625c96665739d3de"
    sha256 cellar: :any_skip_relocation, ventura:        "04d2e98419966dbb5e2b803d5d8d47a1f730b3509ef35094dc56818368a7bf3a"
    sha256 cellar: :any_skip_relocation, monterey:       "8a6ab3174cd8e75236b93771a171f83f5ca4148ce3f6803db22f6b7eff8f8852"
    sha256 cellar: :any_skip_relocation, big_sur:        "c06cb1bac6b944dea288db7e6e3b95a218f03042e2dc5643c87711f5fc698f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf8a48b72fc2974d032298f0580cd185d081c0a44810113b94494a355ff45d2"
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
