class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.24.0.tar.gz"
  sha256 "6ac763a21162240855cc1695f7aa7ece936db2f5ed3d327ac02266fcff33c491"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cf8b6caef5a0421f90e047fbe8435819f8d88f63d30e7b5745a069884105c09"
    sha256 cellar: :any,                 arm64_sequoia: "9b73315963922327ec00df002e64507bad1ad8b36fd2f00d38d0f99e850a0ce7"
    sha256 cellar: :any,                 arm64_sonoma:  "3d5938f23c6ffb7efef142a22b6ee0bc225cd376ad1cf81ba7ed2ba31d70b595"
    sha256 cellar: :any,                 sonoma:        "e59610ceb626f61d863539bb4425150e62287c3b12546a4d338a75178d5afa96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be62ee39ae38e2aa6019ebb29b94c3982a9d81fbbc6a80186159f01a57889ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2291af32c857ea76d95e651a65e52a5fb798e80b376a8535ac6e81dea3688c05"
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
