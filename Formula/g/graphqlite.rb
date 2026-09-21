class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "736b1de695785761f998b20ff25e0284a3b5485f1c48a4741a7a3025410e348f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3c3087d0fa377b92a42d55691f763632ce7fac148bea907bf0fe62e40055f543"
    sha256 cellar: :any, arm64_tahoe:       "4245e90c88b1da0398dd28fa13c5207d0327246ab9f86e3f669b036b3c5dfb7a"
    sha256 cellar: :any, arm64_sequoia:     "deb175b3876d3a546f8a8770c4c7f19d229fcd2efef035a70463bdde66613d71"
    sha256 cellar: :any, arm64_sonoma:      "f9b7bd6f2cc4f4ec1b0ea22bbcf1d1ab7f3d6941fb20531fb0a2372ab285a5a2"
    sha256 cellar: :any, arm64_linux:       "374bf22917b8ac16acc1dff150016b7c1f6faa25879874f4db6f0f25d80271d4"
    sha256 cellar: :any, x86_64_linux:      "16236149440b8c1e97cd1a7411ad64ed9dc3e2e824f190c0885954a371096813"
  end

  depends_on "bison" => :build # macOS bison is too old
  depends_on "sqlite"          # macOS sqlite can't load extensions

  uses_from_macos "flex" => :build

  def install
    system "make", "extension", "RELEASE=1"
    lib_ext = OS.mac? ? "dylib" : "so"
    (lib/"sqlite").install "build/graphqlite.#{lib_ext}"
  end

  def caveats
    <<~EOS
      The SQLite extension is installed in #{opt_lib}/sqlite.
      To load it in the SQLite CLI:
        .load #{opt_lib}/sqlite/graphqlite
    EOS
  end

  test do
    sql = <<~SQL
      .load #{opt_lib}/sqlite/graphqlite
      -- Create people
      SELECT cypher('CREATE (a:Person {name: "Alice", age: 30})');
      SELECT cypher('CREATE (b:Person {name: "Bob", age: 25})');
      SELECT cypher('CREATE (c:Person {name: "Charlie", age: 35})');

      -- Create relationships
      SELECT cypher('
          MATCH (a:Person {name: "Alice"}), (b:Person {name: "Bob"})
          CREATE (a)-[:KNOWS]->(b)
      ');
      SELECT cypher('
          MATCH (b:Person {name: "Bob"}), (c:Person {name: "Charlie"})
          CREATE (b)-[:KNOWS]->(c)
      ');

      -- Query friends of friends
      SELECT cypher('
          MATCH (a:Person {name: "Alice"})-[:KNOWS]->()-[:KNOWS]->(fof)
          RETURN fof.name
      ');
    SQL
    assert_match '{"fof.name": "Charlie"}', pipe_output("#{formula_opt_bin("sqlite")}/sqlite3", sql)
  end
end
