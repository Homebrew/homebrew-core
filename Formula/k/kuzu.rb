class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "df185b2688ccbfebfddf11520532caf2965300fd91c0c2b9d096da59c925228f"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb7aa1820a91f16e0bdeb5f7c53712283bd554ae81620d1ba88fe42659ba463d"
    sha256 cellar: :any,                 arm64_sonoma:  "98c6ea68a10e431295b2462087c3708c9d2bc20f0692183cd6a20afd742a3e87"
    sha256 cellar: :any,                 arm64_ventura: "e08626d3676a27d8bb7982947ef08ff583c1a85bbb2d6d41354ca367b2b25dd2"
    sha256 cellar: :any,                 sonoma:        "8eb48a39122afdeb15918d77e0e9ffc0317d439ca31e417bc9cc1fd45b8d4c62"
    sha256 cellar: :any,                 ventura:       "2d313770379129941835d3af9c31b8b3c4b2681330179ef30b1fee40ddf14374"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79e4eb188a959d8a693738357983cbffab94b17219276bc57692b7bc76f323d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c16f0f1a7ee33ad239617882f1282a04a62606ded34fbbfdb7de79e0e9427c"
  end

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "gcc@12" if DevelopmentTools.gcc_version("/usr/bin/gcc") < 12
  end

  fails_with :clang do
    build 1400
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "11"
    cause "needs GCC 12 or newer"
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
