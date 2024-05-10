class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "711fdcd404e451b2be0fd90db00e1fe4c26f396000f79559d7fc9308f3ebaaa0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5ddd0408fe2de43941e9283d45dd20fab0c75ab81f6bd65575fc63beb21faaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba71b7aec586e915ea4e4a0ad30a59b31abd3e0fd925d2b39fb4a9e91ca2331f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c85eac88c342838bbd355ac8d1a79c654fca0d66e6ed562ef4103cc62635670c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fec06b5bb88fc34f4c33f87e46ec7d6e22c18bda16884ef1ed64d65a6dcba92"
    sha256 cellar: :any_skip_relocation, ventura:        "e58621c9f3dabfc2bfd5a6986377922c1f8c61229b4ecb1cbdd0a53ba0d3da21"
    sha256 cellar: :any_skip_relocation, monterey:       "b10c485e2f25cf417e904827bbcd736bdce7f51c9730c239755b0d64db5b187c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a974cb06a0549a4276633d4ba6c04750e35c1533eca394603651d9a67de1dfa6"
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
