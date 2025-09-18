class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "9340f1151ea6c9f35c007f122d6e08ec119b5c1db743f0303d40ac8a8e2a5d55"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b75a9039e2a33b9609789ec82f878efa1789c5df1c19e9fd9f36988aae01179a"
    sha256 cellar: :any,                 arm64_sequoia: "573aa3e28749eff8792dc8bf930ad699a835a869b995a05d5297823b67cecb8b"
    sha256 cellar: :any,                 arm64_sonoma:  "a1fec350a28857a60825eb473d02361ed5b1485b15ee1349636e7da69650682b"
    sha256 cellar: :any,                 arm64_ventura: "a0b3a51491ad3b6ba266315954cb0cf1ab8666572f49d2318352f1e3d7151257"
    sha256 cellar: :any,                 sonoma:        "41a84c0407b44907bc9d3599e1817e04d5d37e71fde044ae7a566ed526d2c10d"
    sha256 cellar: :any,                 ventura:       "1e85a9fb583f56bfdb09cc0661f6dbe8615393483e0f3a99f5a019edcdfea38a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39ed6f96904850e2a5d059ef6c60a56b350674382adbd8f391e4d8c19bf6d85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781859e1e45d567ed5cb6f880362b3f0ef12a1250367a7709afa589ef4f38921"
  end

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
