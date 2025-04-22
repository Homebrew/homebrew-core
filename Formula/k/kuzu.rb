class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "b4b687ad9c901584ccb2142f5c2f2d3b8a99c272c09b119c5412c06d7d230668"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f618fb4bddb81e14c2efbad684057b88f615156e6bbf5f148584e083950f7b67"
    sha256 cellar: :any,                 arm64_sonoma:  "2afded37cf67ff4b4fe9918b1308666e237f3397bfc464fb84514c24b0f3eae5"
    sha256 cellar: :any,                 arm64_ventura: "6e62c52cd42fda209d5455329210870bbe76be57b9e586160b2fef606fb2fa94"
    sha256 cellar: :any,                 sonoma:        "567dbb9cc6b796f8e172786caa95c907853edb39a41b4a5db942abe161e12be3"
    sha256 cellar: :any,                 ventura:       "cb35733f74d030f7a636d17f35f9cb8be5967189f079b49125fd8a92d7ac1efe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc1701c3f3ea2a95ff9d350b208f95f095d8d47143761fcf08b10ed56d2dc22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de67eceae5e106351a704b539a9db3cffa4e0fd5df4ff75501a5304f08118d69"
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
