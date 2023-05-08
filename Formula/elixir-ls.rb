class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "a048e8b2fa1fab1ec34d6d99ffd2295762f8c5c3f9fd0aa0aab916b0f2e99629"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2069fdc5e25396179c19442b5f304245900ae2fb7b989791c90dd31cbe4754c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99dbd2f6f41a311bf18966975b237a4b7b81e0a56673d0dae7712bf11357e61e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c26ddadf443a6b6895502980a352885a84baf6573002b0f2a5cfdcf8cd44312e"
    sha256 cellar: :any_skip_relocation, ventura:        "ea6ab54bcba99646091817396722075c6483c7ef7726ee8bd7e603f3f6c89faf"
    sha256 cellar: :any_skip_relocation, monterey:       "1748f678fcf051bf1c0f29243793889147cf0e71a4e1a39b26bb7edfb3e8099b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c928d016abd6c3f31bc1965cf12626195a8c4883e591b15b4e094f733f08bca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d3d6de1a797181fc980cb5e7bed7e473c79b13344a8f803c10f81829525f40"
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
