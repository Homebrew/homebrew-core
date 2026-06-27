class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.5.tar.gz"
  sha256 "b2647e9f917efb04d7df39748e48c521fd55e169bae36ee08fbfe074c223293f"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "693f278b8a9747d247d0ca6a0a9b78d527c087bea62ae6936237d1ad0c4f488c"
    sha256 cellar: :any, arm64_sequoia: "f8a97f70c18a75382d0669e2a96ed8e95c88f7650670826a3297b82e1ff9f35d"
    sha256 cellar: :any, arm64_sonoma:  "084b762de291dcdd1dd5a9a72c9e365b4f859568b85f792138fd926205205289"
    sha256 cellar: :any, sonoma:        "938cddccd164114814a7c1475cbaaeb9b4c274815b9a86b3d69e9860da5689c1"
    sha256 cellar: :any, arm64_linux:   "63db8cd4c3a0175a30ed004673a7bee71da69c5536f20a9e3fab5a97050f6335"
    sha256 cellar: :any, x86_64_linux:  "dd907a53f4ba1586e76a6aad112792c5db080b10752c7a382ff46ab29ca0d7df"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "libpg_query"

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
