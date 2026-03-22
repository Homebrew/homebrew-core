class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "c51353c02801f98a1495a3bf2ec5f716093537fb77a08b444d752b0f2cc89d16"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de74e8091ca13ba1f060a99359822aec132c96e0ee26314f74327177373a0b62"
    sha256 cellar: :any,                 arm64_sequoia: "43e87000f47057a1cfed565717f465057c2c1bd008cac7ace3016581299a094b"
    sha256 cellar: :any,                 arm64_sonoma:  "d7031526d16d8f041ec7a71c5a685986db5609e99f5dd6366138c4754bf300d2"
    sha256 cellar: :any,                 sonoma:        "c6a6c054820ff746d39d4ec73088a981c727185fc81d6eb4a79ee4b34cb2d9b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d2b87209978b860c545c9399a976cd35cb672ca0abb450ba498bf4902755259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed6a34fd27ebc533e9eba05e746507bfe0360eb811e2e0c0cb6281f10449450"
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
