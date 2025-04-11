class Postgrestools < Formula
  desc "Language Server for Postgres"
  homepage "https://pgtools.dev/"
  url "https://github.com/supabase-community/postgres-language-server.git",
      tag:      "0.3.1",
      revision: "b978a5a93016593be5f63736c607e04f8fc7699d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(\d+(?:\.\d+)+)$/i)
  end

  depends_on "llvm" => :build
  depends_on "rust" => :build

  def install
    ENV["PGT_VERSION"] = version.to_s
    system "git", "submodule", "update", "--init", "--recursive"
    rm(".env")
    system "cargo", "install", *std_cargo_args(path: "crates/pgt_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgrestools check #{testpath}/test.sql", 1)
    assert_includes output, "Found 1 error"
    assert_match version.to_s, shell_output("#{bin}/postgrestools --version")
  end
end
