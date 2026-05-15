class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "f70840ab7fcf934c01ac13b6db6eee8b5511b8992abe350e898f618e12f94de9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e68d851871d4adb0df91cfb644e16da7ba2bd81bc26b5288d17f5262f93adff"
    sha256 cellar: :any,                 arm64_sequoia: "65ffe8aa1006828ff672175e753e3c5fe10e5c7e4c5b7570205ae8bb1e6d4ab8"
    sha256 cellar: :any,                 arm64_sonoma:  "8a313647d5ccbb7fa139298d7d05eb96ff8141d0afa84e3eb9b053c5477d7526"
    sha256 cellar: :any,                 sonoma:        "ed68b247267e5c614ff1abb9e88cef761c9c4eaac905d6e2d97d21f3675d34cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "982b76b216a5ab15f1453a7355399c4a973dfc26535296080f148e002399d7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a9956131cd16edbec497d30682f43063c150f28901076fed6f138b98c16bd1"
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
