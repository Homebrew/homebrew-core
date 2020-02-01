require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.5.1.tgz"
  sha256 "0ab43e873a859d323f2f5a0069a8bef3acfa72b09769be3350c9d43c5bb489a0"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e18afc3c9bf5946a437ed3e23111104f097dbc44cec7144366c156f299858aa1" => :catalina
    sha256 "60c0305f1d1006d2d961057b6f63e47ef215332a2a7e8ac44c133a083c262424" => :mojave
    sha256 "8d5caa544b9f2a6248e1058d8ed89f9e2c2eb7296752cbf2cdd0ac0b652e2be9" => :high_sierra
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
