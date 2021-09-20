require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.6.0.tgz"
  sha256 "4a357479548aa8b62725673c9de4481e052c4ecb616152b76c24d2c06e362877"
  license "MIT"
  head "https://github.com/jashkenas/coffeescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e58a5435e6c6321655e5b6991d363718b74913537bb92f25a78d7832ad0b27b9"
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
