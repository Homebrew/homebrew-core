class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "e031dd4f51e719dd945ac96b271a952554c4f7ba6239533b6c23d58123fedf28"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7c2de79deb462b33974ad7ba228e763bb828c12f28547bac69260a459ed08eab"
    sha256 cellar: :any,                 arm64_ventura:  "e820f66b5bbb212c134fdc9269767f0447ab6dc57fca549de6d25dac7665cc61"
    sha256 cellar: :any,                 arm64_monterey: "e3615c738eb25b3d1b36f50c521abec6492d9cb2be95d7b57582489fc3e1a26c"
    sha256 cellar: :any,                 sonoma:         "bdad23ddd7a5ff2f23d6402e3c7a862691a41545badcc66b8bd3c67c73a3bfff"
    sha256 cellar: :any,                 ventura:        "76c3b01c761a5afea8ddf899ce35ca541a8fdbdc6cf3957eac1bc7d8c683d408"
    sha256 cellar: :any,                 monterey:       "3f9df70f537ffe79bc4273f6ecd893585a0527d7aade9d3a4f687434851e802f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "904628ecdf32fa0bc7f15424eb9ff311ef83b4267d921d3ebf55cc7712a3c3f6"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1400
      ENV.llvm_clang
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture arm64:
      #   "std::exception_ptr::__from_native_exception_pointer(void*)", referenced from:
      #       std::exception_ptr std::make_exception_ptr[abi:ne180100]<antlr4::NoViableAltException>...
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    args = %w[
      -DAUTO_UPDATE_GRAMMAR=0
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
