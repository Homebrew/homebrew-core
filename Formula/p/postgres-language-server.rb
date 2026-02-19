class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.21.0.tar.gz"
  sha256 "e43461f0c98f3fdb9f42b0fd3b4d7c54f4095513e802eac0cd421e4f2e6cc767"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "926ee03e7cb3a129772305e64e15fbe81582c240a13581db079e5a053bcce27a"
    sha256 cellar: :any,                 arm64_sequoia: "a1225454717fe8a64a1839b76ccbdc1886d336c33a3e843e3364c2916b8ab945"
    sha256 cellar: :any,                 arm64_sonoma:  "2e9f19fdfb5a4655b73c1e98396db74c5ad71800b2824455eaa777510109e095"
    sha256 cellar: :any,                 sonoma:        "03bad6dcad6f89c5f203d174dee0ebb086d0a36552dfea121f5e5f74b9553070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "007203d2be4c18a14ceaab825157d0508c4b66e93dd4999a6b25d7209f778cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa638af5cd4316583c8036b20cb3328a105e1bcfb3dec841832eff27e1a73f9"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "libpg_query"

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = Formula["libpg_query"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end
