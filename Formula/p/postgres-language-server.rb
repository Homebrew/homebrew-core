class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.22.1.tar.gz"
  sha256 "2f6891c32d85e52fea11645b273670f99bade9ebf6b90f2a90eb4c3560a38969"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a537e0821c71ea60d362e82fb2e1d994a2cc7ef2ab1a407243e82e028b336bc8"
    sha256 cellar: :any,                 arm64_sequoia: "aa4a513a516e86673f67a70caa82b5cb813f564d2d441009a7da219351ecf445"
    sha256 cellar: :any,                 arm64_sonoma:  "774827907bbd4cc013c5fe7e463d6316ec48a221204c66e9a54615b5496d2cd9"
    sha256 cellar: :any,                 sonoma:        "1388a1fc1ea0c1f710f9bdb9648a4cb188696fd514137b65915a1ce21f23f3a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3119fe0190eb7a3a80eeded39900c1a4e632b4f23919b72b0f3df06d422dd31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61a0bcff6656e26c54002584a89f86dffb42456340b09227e2bca1847e951d61"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "tree-sitter-cli" => :build
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
