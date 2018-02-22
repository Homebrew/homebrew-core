require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.2.2.tgz"
  sha256 "c24e388d279a813ed91d6bf5a10ada64fc2779a2fc38e79b98d8819ae7a59886"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "222c62641169f501b10e8fe728721bd834853ba6dd22b26b21bed29285c143d4" => :high_sierra
    sha256 "6e4eb53c2bbae2512f779f35365e6718931e61d5f31f1479048f5d44c67f36af" => :sierra
    sha256 "d22f4d9b273bb65608c35ed98ddd0356aed763df347c8afbb68282331dada2f3" => :el_capitan
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
