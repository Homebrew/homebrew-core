require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.1.tgz"
  sha256 "a5bb30170ae1126ae8cd20284d070c336aff1b7fff89f0b7d97ad11a7e74b9ce"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac301a2dc4dfeb8556a849d008675f732df7323de1ee492b62635fc3ecd45f49" => :high_sierra
    sha256 "3e9ab6e5c542380f6d3e5704943a7275e95e5bfacd4d4f435ffd3ff86ae4e255" => :sierra
    sha256 "82ceb98cd075dc9ec9baab2642b30111686373445d09b1b5103419015e9ccc6e" => :el_capitan
  end

  depends_on "node"

  conflicts_with "cake", :because => "both install `cake` binaries"

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
