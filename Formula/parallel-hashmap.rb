class ParallelHashmap < Formula
  desc "Family of header-only, fast, memory-friendly C++ hashmap and btree containers"
  homepage "https://greg7mdp.github.io/parallel-hashmap/"
  url "https://github.com/greg7mdp/parallel-hashmap/archive/1.32.tar.gz"
  sha256 "50cc7abc08f78c6396a33a334e5bc0b3ade121af8604690dae13a1bad47cf07c"
  license "Apache-2.0"
  head "https://github.com/greg7mdp/parallel-hashmap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "932e18bb079269506931abfe4722a1eab66bb83f850bb5952c982b21864679a3" => :catalina
    sha256 "d020435a32c4fe59e1bbc0f0e744726b81cade9f89fd871fd49487c5c8a3958f" => :mojave
    sha256 "c3e7184629352580841f4e14d032eb09653e2dcc4d36f107113e8784ac45060c" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <parallel_hashmap/phmap.h>

      using phmap::flat_hash_map;

      int main() {
          flat_hash_map<std::string, std::string> examples =
          {
              {"foo", "a"},
              {"bar", "b"}
          };

          for (const auto& n : examples)
              std::cout << n.first << ":" << n.second << std::endl;

          examples["baz"] = "c";
          std::cout << "baz:" << examples["baz"] << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "foo:a\nbar:b\nbaz:c\n", shell_output("./test")
  end
end
