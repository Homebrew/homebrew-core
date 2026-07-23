class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.6.tar.gz"
  sha256 "c54f556a194a9d82dabc95d032e36e87a40d99c2a0ce37dad8eb5069ab366adb"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "619a532989e8aea10995e9133dcb4aecfb0661418dd8251491051ddced11d711"
    sha256 cellar: :any, arm64_sequoia: "8de47171eaa13d86abe9d2527af8e423a6398d9a8a0d951216b9566c3ff1283d"
    sha256 cellar: :any, arm64_sonoma:  "84c021a65301a4e7885896a2e4dabf876d02e7051a6e9ff75f4738229414bafb"
    sha256 cellar: :any, sonoma:        "1d3e4d94d2068577edee35a5013bd156e8fe6dc273fd138f59f0269635505f5d"
    sha256 cellar: :any, arm64_linux:   "c8dc5bb2db149a0d403a322e902f31f8641bdc308b090718ba9f8c9f42303511"
    sha256 cellar: :any, x86_64_linux:  "524132a436acb1be52a3481a753e00dde83712415375219f993861c6e9fd00e0"
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
