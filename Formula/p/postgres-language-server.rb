class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.17.2.tar.gz"
  sha256 "05e8cd8dcee06974ccb10c6371d2ecd871e024d51cef5c95ff429862afc50252"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b902f96e99e20f2b597f032da9ece01e4c67f7c2fedf1a41832244019ea4caa"
    sha256 cellar: :any,                 arm64_sequoia: "f21869b23db9a186e6ecc6cff40ccd24c5d4239fef7887b53d4035e1e07851f1"
    sha256 cellar: :any,                 arm64_sonoma:  "fba208f8d36d825a9be2f9cb56ee57ff856b5c0ec9ca1d48cb5e761ba30c6ea8"
    sha256 cellar: :any,                 sonoma:        "607cdca7a4040e31e679ff65cb06d41b9492de8aebb4ac753f8afc3aae84aca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e70cde4802daf411a8f7ad31444b754874ca286d1a905f167063bafda671280a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df82689c8cb1a7c0d594b171da01bd7f0750fe03ad6196e2d6793f695526217c"
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
