class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.23.0.tar.gz"
  sha256 "a42e6e155a2f667a691a7a4bd2f9e9055cb1a80631f9a7cedd1720cd11062cc3"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59f6bf55d319bb3776f56cb6a4e8d7d637ac618aa04888bdcc1e41e8fc7416e2"
    sha256 cellar: :any,                 arm64_sequoia: "caf02557f03a3abc25c694699b91ad83f6a22c65b5d9c560937ca015902c0901"
    sha256 cellar: :any,                 arm64_sonoma:  "94b008e4d9928b9238531fa866adde5071c99ba0128361a284a8e9b4bf138184"
    sha256 cellar: :any,                 sonoma:        "4cf2875eaaabe206e3c7488d627721fed0882e85dec6765cffd9a671e44c150f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "190b1eb2af2cd7cff0f935d8c24932005757c25494e8b7c7ed975d461c2a1c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d98bf70f80ad4a819d3a2c7adb8ceaec8affed167afa438714812cab1f1b20c8"
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
