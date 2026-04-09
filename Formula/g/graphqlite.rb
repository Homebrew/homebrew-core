class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "1886f9f817500fcbbf47fe957bde54eb7d6c34a19de5fd9f9568249903c8d879"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74ec0153dae2cff17ebb9409e474ff94f7becc5d1be353592434a42cb1f89d60"
    sha256 cellar: :any,                 arm64_sequoia: "5fec9eaccc924e23127767ceca27d33c744abb93ff51c751061dcf29e1c9a911"
    sha256 cellar: :any,                 arm64_sonoma:  "f02578acf41d1865794ee6386f181095a574dafabbcd0dd5452c3dd0bd7b6c25"
    sha256 cellar: :any,                 sonoma:        "d7d99588bc68286b33ffeb369c1d27c7a00e6779fd6b6df37dde56baf5063b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c15826428e5cd9b225772d92a8790ce6d2596353e86bbe0a7ed2bf4bf2c187c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00396c1c5a282a3f8a586dd6d8c611e4ca1a6a57b4c332ea95d6e73427c52d8c"
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
    assert_match '{"fof.name": "Charlie"}', pipe_output("#{Formula["sqlite"].opt_bin}/sqlite3", sql)
  end
end
