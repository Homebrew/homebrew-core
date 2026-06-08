class Graphqlite < Formula
  desc "SQLite graph database extension"
  homepage "https://colliery-io.github.io/graphqlite/"
  url "https://github.com/colliery-io/graphqlite/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ea5a3e6d333b24e9805ae165980585026fbb310eb61ab4f3f4c52a228aa331b8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "167afb813803602177be49f6500f08f119af7f8743e89ca9ead5a6fb8a1c1924"
    sha256 cellar: :any, arm64_sequoia: "572f27a23036574986cc4723a044fdf06f22a2229cb42bcc8bbb92fb1d015fde"
    sha256 cellar: :any, arm64_sonoma:  "bb423248e45a679435edf554357f938dd57c77dc884f2871f002611ca6f5afb3"
    sha256 cellar: :any, sonoma:        "20c38d78502747772277db3858153541463c5e24ab0a8a08adc7228032b5eb81"
    sha256 cellar: :any, arm64_linux:   "5db0fab0edc0c9386e1418e38653672dfaa81f25202ab39626be921d3a6e5480"
    sha256 cellar: :any, x86_64_linux:  "75a00f6cfb83a6482efa03ea0ce3c4c08c0301e15fec9c5747fa7ea7a542dc23"
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
