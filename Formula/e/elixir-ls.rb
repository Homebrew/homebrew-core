class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "aa142dbd3ab34db160a6d9ff63c2885a3313ae70148075bfcf3ebe5a767ad044"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59325f5ed48de38ea530b845d882ad423a17d5329efcbfe4903dd7b16f355a4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59325f5ed48de38ea530b845d882ad423a17d5329efcbfe4903dd7b16f355a4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59325f5ed48de38ea530b845d882ad423a17d5329efcbfe4903dd7b16f355a4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "59325f5ed48de38ea530b845d882ad423a17d5329efcbfe4903dd7b16f355a4f"
    sha256 cellar: :any_skip_relocation, ventura:        "59325f5ed48de38ea530b845d882ad423a17d5329efcbfe4903dd7b16f355a4f"
    sha256 cellar: :any_skip_relocation, monterey:       "59325f5ed48de38ea530b845d882ad423a17d5329efcbfe4903dd7b16f355a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff87333cdd3f9d82ec4b693e2bb4e66b91242f618d752c11d8c008d70a54452a"
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
