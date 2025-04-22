class Datatype99 < Formula
  desc "Algebraic data types for C99"
  homepage "https://github.com/Hirrolot/datatype99"
  url "https://github.com/Hirrolot/datatype99/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "f38c077afdb91b7d754321be5d3c4a43ed5420c1ad51514d1de20023960f9a8e"
  license "MIT"
  head "https://github.com/Hirrolot/datatype99.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de27c538560d8993175a1c972437f30e9de4d719154b3a4851f154610cb577b1"
  end

  depends_on "metalang99"

  def install
    include.install "datatype99.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <datatype99.h>
      #include <stdio.h>

      datatype(
          BinaryTree,
          (Leaf, int),
          (Node, BinaryTree *, int, BinaryTree *)
      );

      int sum(const BinaryTree *tree) {
          match(*tree) {
              of(Leaf, x) return *x;
              of(Node, lhs, x, rhs) return sum(*lhs) + *x + sum(*rhs);
          }

          return -1;
      }

      #define TREE(tree)                ((BinaryTree *)(BinaryTree[]){tree})
      #define NODE(left, number, right) TREE(Node(left, number, right))
      #define LEAF(number)              TREE(Leaf(number))

      int main(void) {
          const BinaryTree *tree = NODE(NODE(LEAF(1), 2, NODE(LEAF(3), 4, LEAF(5))), 6, LEAF(7));
          printf("%d", sum(tree));
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["metalang99"].opt_include}", "-o", "test"
    assert_equal "28", shell_output("./test")
  end
end
