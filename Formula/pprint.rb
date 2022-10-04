class Pprint < Formula
  desc "Pretty printer for modern C++"
  homepage "https://github.com/p-ranav/pprint"
  url "https://github.com/p-ranav/pprint/archive/v0.9.1.tar.gz"
  sha256 "b9cc0d42f7be4abbb50b2e3b6a89589c5399201a3dc1fd7cfa72d412afdb2f86"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "2bd9ae7e3fd65f467b6416bf779f79aa7bb30ab6a064a3971b4cd5fed16fd234"
  end

  deprecate! date: "2022-05-24", because: :repo_archived

  depends_on macos: :high_sierra # needs C++17

  fails_with gcc: "5"

  def install
    include.install "include/pprint.hpp"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <pprint.hpp>

      int main() {
          pprint::PrettyPrinter printer;
          printer.print(std::set<std::set<std::set<int>>>{ {{1, 2, 3}, {4, 5, 6}}, {{7, 8, 9}, {10, 11, 12}} });
          return 0;
      }
    EOS

    system ENV.cxx, "main.cpp", "--std=c++17", "-o", "test"
    assert_equal <<~EOS, shell_output("./test")
      {
        {{1, 2, 3}, {4, 5, 6}},#{" "}
        {{7, 8, 9}, {10, 11, 12}}
      }
    EOS
  end
end
