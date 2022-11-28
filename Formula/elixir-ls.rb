class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "14f8a51b6f29c242bee5f963d16596afe3f0bfc8447ff2220570162f42c63641"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e13ea97c7ad0f5ccd06807619f500f78cbc1bbf686114e67984f4dd046f2e5a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5467e24cda93cb6f08f9db820f7d9e9c624935a8b7dae37398b7f388669b4847"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2a5bda7b31255283eade45dbf9f1b0e16139a5cc849030d73f1f142ba0d60aa"
    sha256 cellar: :any_skip_relocation, ventura:        "346826a1ee5ff0ab04ac39f56cbd6e873b0b175e7997da83cb6a4a5ee0be0c35"
    sha256 cellar: :any_skip_relocation, monterey:       "bf9f6a487572b4f8630e1994ac73b89bedf150c7830bdff26b3cd8acab4fe625"
    sha256 cellar: :any_skip_relocation, big_sur:        "e306161b58393478801bcad0bad8a7e776f56a8db5cce1953977221cb2d6728b"
    sha256 cellar: :any_skip_relocation, catalina:       "fe49393124566234cc76a42cda2e7bdab3b6fd8d028468cb7ac5b43a2a7d5d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ececbbf2d642570e9c1d026d047632d05bf56d9802a501badab96cb9fb66285c"
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
    assert_match "ElixirLS built with elixir \\\"1.14.2\\\"", output
  end
end
