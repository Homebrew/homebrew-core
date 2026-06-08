class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.25.2.tar.gz"
  sha256 "d073dd994e0de3b9bcddda7b962c24c151645aaf192cea20a860be2886854383"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6df966658d450c5cf62ce7dbb741bed38f0d26aaab1b16d0e468a2a3a0db3e7e"
    sha256 cellar: :any, arm64_sequoia: "181e64c2243506ec0cbed2d6fc2b669eabaaf36f76b5d793625c0f34c1948abe"
    sha256 cellar: :any, arm64_sonoma:  "d4d05627402e37000ecf2f83630b2771ab940d56e63a9b6dae02593f49e30372"
    sha256 cellar: :any, sonoma:        "ee93aac7bf7a1a53b221367f25cc09d2a6ba0bc763b59b72e5eeb070c0c6d817"
    sha256 cellar: :any, arm64_linux:   "86e15a6c096bfec34c610bf8688243bbc4866b3efa0af044fdff2e6248a1a627"
    sha256 cellar: :any, x86_64_linux:  "690b3d1e2b4fe446b57d699fb2554a5767d440496280c64b954a2c27a1c06860"
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
