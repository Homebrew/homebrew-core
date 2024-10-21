class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "00bbcae4bd47cdb02c4e23de99188312b6478d5f0a2b64a2d48ea24b239a9704"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "218768d818535a97c4d8977dcc386230b81aa757ab816c56afcd2eacdebc1a26"
    sha256 cellar: :any,                 arm64_sonoma:  "0ea525fc338d0e87b7e49106553670ec0cefa019636f20c3c6e196ae6d001a56"
    sha256 cellar: :any,                 arm64_ventura: "db3249db98c1f4da40d12b8d9e375d915b695e7059abcc73ba8d94558c411528"
    sha256 cellar: :any,                 sonoma:        "aa71a7edf5e60da807b58a373cd126d73859f0c39531e945ff3e1e6fd6c8f630"
    sha256 cellar: :any,                 ventura:       "29ada93bbd297e594fb55397765fef8cbd2568a2eb904182bbdae21f0a115ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05b91c67ba816085a1cc5d76bb6b6df3274d37f267299854bcb61ae51e803ec"
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
