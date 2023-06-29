class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9049b03d34bbd9af1fd31af4411e311cb49f0f8cbc9cd070c904f9f813150b0e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfbfa044831fe345d9d86cce970f612f0a7c7be553b6d6d112f20ee63683d9ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47626c0fb41753e8de5983565ed8863f7bf17adc3eba0b21c6bbd6dfb9a89d67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a1db273a4d7556d66276bd169264dab184893eaf03ed65e37ab296d721c4d14"
    sha256 cellar: :any_skip_relocation, ventura:        "6d3e2846d464626d30f77cfea783cc61ef728777b389997d0434ff634afcfa70"
    sha256 cellar: :any_skip_relocation, monterey:       "3d35017eb667fe7839514e0e7b83f6796fb62d926aa80bf190c9a071deda5474"
    sha256 cellar: :any_skip_relocation, big_sur:        "08a03f6187e6f0aa9a464b33d9ea08123a8ed6297f258761df55456011f9b562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4507f23d94bb687f548e7b23a04f1404a4ec35fd60b4963c949e25a0a1cbe365"
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
