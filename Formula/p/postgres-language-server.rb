class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.28.2.tar.gz"
  sha256 "738f169880dffae0c219c88b5c2dae3d2b79fca147e4804f4f4d3362d210afcd"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "148e9bcf6dea74b59138c694409424846a8f6e7edbc19a6b376e72492b520b9c"
    sha256 cellar: :any, arm64_tahoe:       "3817d7842961d5442d57dc11f2a38831b9b1403bc79222652af11f0ea1e73b8d"
    sha256 cellar: :any, arm64_sequoia:     "03de79694525f082a47b9c52dc33ef5e3b1a7841634aa2e5f89bbb4b7c7feaa5"
    sha256 cellar: :any, arm64_linux:       "c6313684b9394ecd6eb308fa818aca5f29de61eaa62778839f0969247258d5f7"
    sha256 cellar: :any, x86_64_linux:      "e31396321e8b62c4838ecbe118483a4008b3da10f0306ae0f2ada29e4df519e9"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = formula_opt_prefix("libpg_query")
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end
