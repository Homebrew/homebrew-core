class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://github.com/kuzudb/kuzu"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "f6456fa290879e4c13db49b8918258c4422d78a57fdc6d8925d4aef23e7a0b3c"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "243bde67ad2135a10f649a5914d9f10e0838b3daf60f974af3812bdd095c9f48"
    sha256 cellar: :any,                 arm64_sequoia: "10f12c53e501bd51cab6f7fa22633409bcea799022497b47ba2886412eb8b2c9"
    sha256 cellar: :any,                 arm64_sonoma:  "dbe0a9c52d265082dba31f9bca611c79055be996e76e7fa684d4e00fef89b20b"
    sha256 cellar: :any,                 sonoma:        "d5103b415b4966f878cbcb4240341d5edd89cb594313b552d7ed463beb4a2769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4b9e39e891e947f5b71f407baf93e3fc3ae2c0633f0f21b12adf52ec8f84c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7efd5a1507ec1b80705e133a206aaac497bdfdf6ae4d3d32309525c5ce5ef8e"
  end

  deprecate! date: "2026-01-20", because: :repo_archived
  disable! date: "2027-01-20", because: :repo_archived

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_intel do
    fails_with :gcc do
      version "11"
      cause "error: unknown type name '__m512h'"
    end
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "10"
    cause "Requires C++20"
  end

  def install
    args = %w[
      -DAUTO_UPDATE_GRAMMAR=0
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    db_path = testpath/"testdb.kuzu"
    cypher_path = testpath/"test.cypher"
    cypher_path.write <<~EOS
      CREATE NODE TABLE Person(name STRING, age INT64, PRIMARY KEY(name));
      CREATE (:Person {name: 'Alice', age: 25});
      CREATE (:Person {name: 'Bob', age: 30});
      MATCH (a:Person) RETURN a.name AS NAME, a.age AS AGE ORDER BY a.name ASC;
    EOS

    output = shell_output("#{bin}/kuzu #{db_path} < #{cypher_path}")

    expected_1 = <<~EOS
      ┌────────────────────────────────┐
      │ result                         │
      │ STRING                         │
      ├────────────────────────────────┤
      │ Table Person has been created. │
      └────────────────────────────────┘
    EOS
    expected_2 = <<~EOS
      ┌────────┬───────┐
      │ NAME   │ AGE   │
      │ STRING │ INT64 │
      ├────────┼───────┤
      │ Alice  │ 25    │
      │ Bob    │ 30    │
      └────────┴───────┘
    EOS

    assert_match expected_1, output
    assert_match expected_2, output
  end
end
