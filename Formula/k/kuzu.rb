class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "b87dcd0bf084350a81c4d85d1322bdb11a7531bfc01e4456284ee9842f0a39c7"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d2dacbb10920115e077c613a7e8e7902967544d4cc7a45826c7e843e5ef1222"
    sha256 cellar: :any,                 arm64_sonoma:  "5f7a932b0fb7842efe5dc54f1b57ead3b560cb880d2817177506680b72effae8"
    sha256 cellar: :any,                 arm64_ventura: "5cc48a6a184a09e9d1a32021be4b311435aed1f3efdecd8a6241a878bfab3067"
    sha256 cellar: :any,                 sonoma:        "199d1f0b6facf0add4a413649df67ed7cb396f3d03465fb927790038fe3d3fc3"
    sha256 cellar: :any,                 ventura:       "a3e5b145c6923a60882112b63220ff033b77f067424973ac9bf3ed67fc6d6b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da969de520e286e67a637e1f9f9ccfd923d6388a07fa762262d46f8f76db697"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

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
