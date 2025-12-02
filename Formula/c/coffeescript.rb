class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.7.0.tgz"
  sha256 "590e2036bd24d3b54e598b56df2e0737a82c2aa966c1020338508035f3b4721f"
  license "MIT"
  head "https://github.com/jashkenas/coffeescript.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8b60f70c34df82c6fb506f905b11ecf0cda8421c03fb775e19ac0a2e9f348edf"
  end

  depends_on "node"

  conflicts_with "cake", because: "both install `cake` binaries"

  def install
    system "npm", "install", *std_npm_args
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
    assert_path_exists testpath/"test.js", "test.js was not generated"
  end
end
