require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.6.1.tgz"
  sha256 "c793b83cfc0d29546743069ed1cb9df6940fd69b4e929a964e47e4ad8637b249"
  license "MIT"
  head "https://github.com/jashkenas/coffeescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43093bd24f42450278f73ee908d5a7893ccb5fb55b8393c90236cd3bacc71a6a"
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
