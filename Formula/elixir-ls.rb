class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "539dfcba5206410da03711902b2e99ddeb40d5aea0644c8c4074043b08038396"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f27e6f2547be41d589f2de620f8b2f7ad47212072fadedd3224c3e07ef696b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1967f16e47616d3d2f1bb1eb08bada9897639948f16607b4e6a88d518f0ad719"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62be559d6d435df093f39c60dd29209fbe33e1080501a247536e5958f149ccf9"
    sha256 cellar: :any_skip_relocation, ventura:        "eb4d8fddafafc7aa98b54755651a715154f5204eb7501e0d948e927630edd5f6"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd543054e7a8523ff59df64b72112da934c3f7024b9877f4d01fc8cfe8e3808"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fa76786b50949377b86d1caf585dbe3d44a1f8f0b0f5aefd9744573e996ba54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e7cfad64ec373bda089e6e080a32bb4edfc73d2206558738ce7890b41ea2a50"
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
