class ParallelHashmap < Formula
  desc "Family of header-only, fast, memory-friendly C++ hashmap and btree containers"
  homepage "https://greg7mdp.github.io/parallel-hashmap/"
  url "https://github.com/greg7mdp/parallel-hashmap/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "949874f4207b8735422438b23b884fb1f4b926689bb5eebff38cc4d357d09cd2"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/greg7mdp/parallel-hashmap.git", branch: "master"

  # Upstream switched from a version format like 1.37 to semantic versions like
  # 1.3.8. We're working around this by checking the "latest" release on GitHub
  # until there are newer versions higher than 1.37 (e.g. 1.38.0, 2.0.0).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28bb19b17276b3d5f13fcd9bc74000a6f426530df7484e7f218c53c1fa84da4c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "foo:a\nbar:b\nbaz:c\n", shell_output("./test")
  end
end
