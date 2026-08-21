class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "915dcf461411bf5a1ff5a13639dee832616b9b11b6efe911a86927c3d1930b67"
  license "Apache-2.0"
  head "https://github.com/elixir-lsp/elixir-ls.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0788f842a7ba329056572b0aaf459f265d1044e7493de645ac9e83c3713021d0"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release2", "-o", libexec
    rm Dir[libexec/"*.bat"]

    bin.install_symlink libexec/"language_server.sh" => "elixir-ls"
    bin.install_symlink libexec/"debug_adapter.sh" => "elixir-debug-adapter"
  end

  test do
    system "mix", "local.hex", "--force"

    # Test language server
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"elixir-ls", input, 0)
    assert_match(/^Content-Length: \d+/i, output)

    # Test debug adapter
    json = <<~JSON
      {
        "seq": 1,
        "type": "request",
        "command": "initialize",
        "arguments": {
          "threadId": 1
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"elixir-debug-adapter", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
