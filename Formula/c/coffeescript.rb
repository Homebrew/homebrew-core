require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.7.0.tgz"
  sha256 "590e2036bd24d3b54e598b56df2e0737a82c2aa966c1020338508035f3b4721f"
  license "MIT"
  head "https://github.com/jashkenas/coffeescript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca7fa9078c1169f542f4b95ed89dfacbc69b02f50345c03656763f801ffc9cb3"
  end

  depends_on "node"

  conflicts_with "cake", because: "both install `cake` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.coffee").write <<~EOS
      square = (x) -> x * x
      list = [1, 2, 3, 4, 5]

      math =
        root:   Math.sqrt
        square: square
        cube:   (x) -> x * square x

      cubes = (math.cube num for num in list)
    EOS

    system bin/"coffee", "--compile", "test.coffee"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
