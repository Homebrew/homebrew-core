class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.19.0.tar.gz"
  sha256 "e56f5ca8a1c3efb0998256108b6e9f3ed3b23dd397bf5c7a4ab995b6f8a1ed27"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c70084a95444c0e9942166a94b798659614d354cfbeb1e548ab73fee4daead9"
    sha256 cellar: :any,                 arm64_sequoia: "7d464de81c5ede249c83b4591af03cd04667d5f89e12cbc6cd6a07c14c60efb1"
    sha256 cellar: :any,                 arm64_sonoma:  "25f0af91f8ead0ecc2fcb7b19ebde53d95900091ff57cb4050daa3a2677216a3"
    sha256 cellar: :any,                 sonoma:        "d81059e7fecf8a5989c746319dd3c44ebf8b23d9f23331825e2c9fcdf7c034a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3df2632ec833db54f9d9a5e18273935e4b656a9658be9c1a7ea1a8b185b3e5ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "311a51b92b4a65807eebcc75c746e4d1b3fe60a834e4ec8c2bc1ca280bfb9f9a"
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
