class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "42d6bd70f12c57caf8ad19da091263ac231ff13eea0490ec1faf3c6fe772c443"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6c864e38b19adf83a677abbf5c63f3eedc5fe82fbbfbff3500e5057e442e7fb9"
    sha256 cellar: :any, arm64_tahoe:       "0063f1965129c9d2e7df225397f356702291baf06d73f8f6acbae2363a2c18d7"
    sha256 cellar: :any, arm64_sequoia:     "76a4c9c6ad6a7b867e71aaa71dfaeba6e54817104b62db24136386a056a042d7"
    sha256 cellar: :any, arm64_linux:       "5554db96586da9bd50a335a3ee6e797438aa1ea150aa42b90af4505c7b50ed25"
    sha256 cellar: :any, x86_64_linux:      "273ada91800c00ae923dff8471d053c3126a33c5eeb2586e8dac2fa3508ae169"
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
