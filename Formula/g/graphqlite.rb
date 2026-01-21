class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "5c6daeac31ee0ec7301b16719863e504727fc4dfe7ed9a5122c25acb5d92b558"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91779536d07f221dd500c0656b40fcba7e3bbb4c1b9191beecb281ce87e8cd7a"
    sha256 cellar: :any,                 arm64_sequoia: "914e046ba46019f1e26a316944b8a10e475a4ce22dc992202c6eb37c4f09a614"
    sha256 cellar: :any,                 arm64_sonoma:  "7a899ea5c7f62491ff7e62b65bff6377a890a90740b5ddfb8fb77996cb94edf4"
    sha256 cellar: :any,                 sonoma:        "7bf3b2ccc021a7472877cd76dfaf428cd3231df28bea3fd426e5ffff90391b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f47e56875db1a5d2697b3abb2971b389d4640ea771ca68696a4c139535450e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00fa00ba3718aff84b1dbca7b0a7f5783cd19fe84ee208d4b409de3c1101971"
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
