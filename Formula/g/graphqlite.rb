class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "0399cc6761523d52f004b892925f343e8bff20e91b676b01c6a1c03a367cc6f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6475d5b76f6053ba53b95712be08272e6551b5463aebe649992fe987c1ddaf62"
    sha256 cellar: :any,                 arm64_sequoia: "02c07ec4b80bf4e48f21f2f6ff984cbcbe0ca3a8cbbef4cbb3c4d36009b5a78f"
    sha256 cellar: :any,                 arm64_sonoma:  "38e5954ec6da08541e3a884c1fd963ac9c4bcc39e0824a7c143769564c1417c2"
    sha256 cellar: :any,                 sonoma:        "91be83bef796b7e5ef0a5ddfe371e874f4471af341303db2a810e21170866220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb1a89f7fdda6842d0d45aeb76a52634a9fe7bb8e3856e52dd93226b41e40819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fe96cb5993be9b91dade71ecd8074515713531f83c9a8af047b302fc977668"
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
