class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "6c43511c0feb83108d895051b9bee9c8aeb9380ee2a184837c0e5917afab1337"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "390743e3fce79fa449e34cfd2b13aa6f6210b6c8ac9a723537e7a369212cd47a"
    sha256 cellar: :any,                 arm64_sequoia: "83aebc6ea1e4e5fdef78f7c52cb91b81c2655a50de50b9b2ce1864b907bf0510"
    sha256 cellar: :any,                 arm64_sonoma:  "9c7a751266b08a446e4644e9435ec047feb81807b2e9266a7a95ff2f53d6ee88"
    sha256 cellar: :any,                 sonoma:        "3bbdb2c8fa8779ef485f34668ccd4df75f3f8491f3a1d76750f34476966c3fa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4362739d9307b9282bbc7b2ddd4ca63b5415c048c940ec312b29234c25474b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400b0276e3b2ba77fb6837cfdc25bcb80474ed101e2e38e6f937cf9f92437e20"
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
