class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "d8e6c1b7ffc2a122c280ab9790de3cc22b2c12cf98caeabca66e222c8b6a8da1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b5a157f08e6591c3d7c969df7004590817eca3b7d2f01dde422c4bdc3af6ffb"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release2", "-o", libexec
    libexec.glob("*.bat").map(&:unlink)

    bin.install_symlink libexec/"language_server.sh" => "elixir-ls"
  end

  test do
    assert_path_exists bin/"elixir-ls"
    system "mix", "local.hex", "--force"

    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output(bin/"elixir-ls", input, 0)
    assert_match "Content-Length", output
  end
end
