class ParallelHashmap < Formula
  desc "Family of header-only, fast, memory-friendly C++ hashmap and btree containers"
  homepage "https://greg7mdp.github.io/parallel-hashmap/"
  url "https://github.com/greg7mdp/parallel-hashmap/archive/1.36.tar.gz"
  sha256 "33acf44158a9661a9d630d13f9250a2aa27a770cb3771df77b1ba1a661c0b766"
  license "Apache-2.0"
  head "https://github.com/greg7mdp/parallel-hashmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62b3c2b212276c17c008d2823e4bb3b4c4c1fc8e77f1a82dee40d829b74ed0dd"
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
