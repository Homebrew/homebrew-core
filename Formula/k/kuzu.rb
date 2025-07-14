class Kuzu < Formula
  desc "Embeddable graph database management system built for query speed & scalability"
  homepage "https://kuzudb.com/"
  url "https://github.com/kuzudb/kuzu/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "445872031fd41153dd5a35a3d471354f1a98f853df5aad45a0a47154c69eaf2f"
  license "MIT"
  head "https://github.com/kuzudb/kuzu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0408f5e2309ed34472e5c21d8676a3c885840e8d99361722bc6989035b607a2"
    sha256 cellar: :any,                 arm64_sonoma:  "2b7f0e5c7b5c64a5260bb53f68adbaf55dd9cd583ad32f319d8b21d48697c851"
    sha256 cellar: :any,                 arm64_ventura: "4eac4c3186998375e47d7ea5ce73e42f93ec29f0e0d7f6ea769cc134003f7861"
    sha256 cellar: :any,                 sonoma:        "531d4d3f3d9d9f537211938787659f7100455603b23708f8908570483901edfc"
    sha256 cellar: :any,                 ventura:       "92f1cb902c671432940d4a7ac13297d0661b7840cd91aea22f653ed75c99f3f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af7c73032fc17a5283d678b11653d31ae591c1b052da1ceebe90d998ba29a9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54f3472c5ff2ac7fa69e362434ad0044b23de935627ff01238fb28bf5f2388ce"
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
