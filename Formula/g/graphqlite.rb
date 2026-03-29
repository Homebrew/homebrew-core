class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "8954e3bdaf1c62bd398c002f1396852eac55c4143c88fc7e2f388550b2cf5833"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba1b4b291b9b71db4a1f04038e84f472aa0d0378c9dcdb578f27d262b7dc6b2b"
    sha256 cellar: :any,                 arm64_sequoia: "ae4393e4d5ce3c3734658a23898a9a50fd7c51de11b50d1cad1e73caf7aa54da"
    sha256 cellar: :any,                 arm64_sonoma:  "139620989026f757b01f4d979389c795fe0c6fcdef82f238d8a16619bbbbb6d1"
    sha256 cellar: :any,                 sonoma:        "5f79e9da55cd18e68e27145278f0a712b617edc6e4183d5f342b44e54d1a118c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a629fa45ab3b3c30740225895914df9db15a267e5c3d94e2b8b938b0b1ec061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "332f7d557e18a5caec08e9209a0efbac6d07554d893c34e1bdede51492fe7f2e"
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
