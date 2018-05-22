require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.3.1.tgz"
  sha256 "8c75206dfb8d92d92bff6074a6864106007e9695533d5230d131d4ca947ee33e"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "379a9d5ffbaa4a3accc805dda8c72511db723bea2f9ec8063a6852cdd1df47ef" => :high_sierra
    sha256 "f807420503205fa06c12bb151641c49391ef22ede593ba0b0732f47ff9d83b18" => :sierra
    sha256 "e7a4344481483b239dc47e31ec906bbeeb643a30c349391ca0327ed280592f63" => :el_capitan
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
