class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "cba5b9afb46228c7472e2e2ecc5d7fd99a29e778ce3e726db1dd9f702a68bbbd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2508f07c361fee37a62eff19b9ce0772564ed43467e927e25310cd47286fd59f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bde32d69852db52952aa55e71a9d0e000a3cbb70f9acc41fa0c21ed2556cea96"
    sha256 cellar: :any_skip_relocation, monterey:       "2c6419dab00f7268c698a4ed55b8e0ecb8ee9cb64aa5b7d7c38d49897de1ecc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9954971dd64118ec86bc464fdbfdce2793b9d50fbbd2881791894248deccf756"
    sha256 cellar: :any_skip_relocation, catalina:       "65b16d8a3c5172c7aa9bb3faf189ec3e0e61e111996ef64139b7d23a71101918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1f6cd1e14c2937b657abec11f0d3e1cf5364a6c4fa73670f7d1cd68ab04b416"
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
