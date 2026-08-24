class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.7.tar.gz"
  sha256 "83875c5ea149d2742f4ba777c14391148e790cb2364decae4d3b7365ce20fdd0"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "036455622a7f0937d8fd4942a29fc39cd61d37f81f3d3d918d0736f1ac04f6a8"
    sha256 cellar: :any, arm64_sequoia: "41783ef3482d5565185f6992b7308c778b73c59f65bc5774301d780f235a84c3"
    sha256 cellar: :any, arm64_sonoma:  "9611b6b3b4e0b65d2429dbe1209fde65e4f5d3638d27102dd233b76993b62728"
    sha256 cellar: :any, sonoma:        "9179f011e065e36f32ce104ca98f6763628ac5c559eafd80a3e8cf08e9aae3ff"
    sha256 cellar: :any, arm64_linux:   "183a50ee8c6e380149eb91059887a7d4e4d9b787d0249923c271e728eadbcad2"
    sha256 cellar: :any, x86_64_linux:  "49fd561e20a2da4c4a00701640fba61621a6293c5081cfed6792970668149502"
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
