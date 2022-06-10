class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "cba5b9afb46228c7472e2e2ecc5d7fd99a29e778ce3e726db1dd9f702a68bbbd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58db48a0b346fa46459a1ce9f218a7d6ff0dc04dd04cd036e9f22e7790d5e265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7741ff3f47a66c229add6d8cb41fe36743323d34ebcbf86927555530fa7abf9"
    sha256 cellar: :any_skip_relocation, monterey:       "1465b0c582eb53a898cfdc107f9569b09905cf85060a82739124ac30bc0d4472"
    sha256 cellar: :any_skip_relocation, big_sur:        "c93d53ef7e88d9c4718f2cf968bd45dd71585c8dc585a3c0f3fee588f3e8c0fa"
    sha256 cellar: :any_skip_relocation, catalina:       "cb7117dbc37b193f3e41b85d06b780c72cb2ed4e589d51096ada2402d8469eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca791a9e0f4e50fb5eb8b52aaf15965fb9f85fe9d98b7036f918a91762d1dc5"
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
