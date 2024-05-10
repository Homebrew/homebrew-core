class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e81be1e94dafba5e4a6f08b7f3a530c75926740d47e3a6b198687cd132630b6d"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe73a2155139c0201c8adf45b66d1ae79794aa4d01a4c44d55b267b53a484d2f"
    sha256 cellar: :any,                 arm64_ventura:  "73694da5bd64f8ebd2048331842fe1f7ead1caff2b9adbcbcf9909c8aff5ac3c"
    sha256 cellar: :any,                 arm64_monterey: "85f38b926adbc9404434295ddf290249dcf1abeb6c7ee2ece04b415e678bdf30"
    sha256 cellar: :any,                 sonoma:         "8c2c18146931ee91b987b7f288cd7171adb43ab5f0885f3246b9c8e9127f61cd"
    sha256 cellar: :any,                 ventura:        "2a3fd58f7dafea8ad74636ae33cee6189384051a2577b3f645e0beaec0750613"
    sha256 cellar: :any,                 monterey:       "a5bf8b2b9ed93fbf3394d7972d4f7e43759da182a2793fd522028e1c793ea448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09f6c8c6e9731dda6c8e8e26204418194a95afe4a1024430a7c0584b8b0b70f0"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  def install
    args = %w[
      -DAUTO_UPDATE_GRAMMAR=0
      -DENABLE_LTO=1
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # The artifact will be renamed to `kuzu` in CMakeLists.txt for the next
    # release of Kuzu. This is a temporary workaround and will be removed when
    # the next release is out. See: https://github.com/kuzudb/kuzu/issues/3458
    bin.install_symlink bin/"kuzu_shell" => "kuzu"
  end

  test do
    db_path = testpath/"testdb/"
    cypher_path = testpath/"test.cypher"
    cypher_path.write <<~EOS
      CREATE NODE TABLE Person(name STRING, age INT64, PRIMARY KEY(name));
      CREATE (:Person {name: 'Alice', age: 25});
      CREATE (:Person {name: 'Bob', age: 30});
      MATCH (a:Person) RETURN a.name AS NAME, a.age AS AGE ORDER BY a.name ASC;
    EOS

    output = shell_output("#{bin}/kuzu #{db_path} < #{cypher_path}")

    expected_1 = <<~EOS
      ----------------------------------
      | result                         |
      ----------------------------------
      | Table Person has been created. |
      ----------------------------------
    EOS
    expected_2 = <<~EOS
      ---------------
      | NAME  | AGE |
      ---------------
      | Alice | 25  |
      ---------------
      | Bob   | 30  |
      ---------------
    EOS

    assert_match expected_1, output
    assert_match expected_2, output
  end
end
