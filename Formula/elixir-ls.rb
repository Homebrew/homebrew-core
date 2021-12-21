class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "eaa2f5fd4ab9e497889e25419e4409cfaf808daca06259718668a71de8616e3f"
  license "Apache-2.0"

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release", "-o", libexec

    bin.install_symlink libexec/"language_server.sh" => "language_server.sh"
  end

  test do
    assert_predicate bin/"language_server.sh", :exist?
    assert_match "", pipe_output("#{bin}/language_server.sh", "")
  end
end
