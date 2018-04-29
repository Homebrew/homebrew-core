require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.3.0.tgz"
  sha256 "695dffde7e71860020cfa0048f4f887b7f7066be194e27a821b3bedb3e7b2cc3"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "389afb2d2dbf295a0d62aff49fb8199dbbfd5ca2a579367795ce495f445f60b9" => :high_sierra
    sha256 "3998e1d551930d7a22f1e1fea092227407a13320b8b06a91a93657314556e0dc" => :sierra
    sha256 "cd13f2a7bc49141b139c485dd03365c577a71c57ff83195bb9b99bfa18e2a703" => :el_capitan
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
