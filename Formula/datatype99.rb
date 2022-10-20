class Datatype99 < Formula
  desc "Algebraic data types for C99"
  homepage "https://github.com/Hirrolot/datatype99"
  url "https://github.com/Hirrolot/datatype99/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "0ddc138eac8db19fa22c482d9a2ec107ff622fd7ce61bb0b1eefb4d8f522e01e"
  license "MIT"
  head "https://github.com/Hirrolot/datatype99.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd6236c1485eaa837959e394ba78b8083ad7f87b7f1393b130bec4634ab1228b"
  end

  depends_on "metalang99"

  def install
    include.install "datatype99.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["metalang99"].opt_include}", "-o", "test"
    assert_equal "28", shell_output("./test")
  end
end
