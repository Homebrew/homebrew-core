require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.3.1.tgz"
  sha256 "8c75206dfb8d92d92bff6074a6864106007e9695533d5230d131d4ca947ee33e"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaca241c7e0891044ea1d21582b9df86813949ab4b93c6aedae6d97134a05ba1" => :high_sierra
    sha256 "d855c47f212359ffdcd350d851c924124f22528b0b53709005bfaa28eac2c721" => :sierra
    sha256 "50ba107ce918fe8d188ed577256d456fb7f007a92a3433f54ed6b29679ce2321" => :el_capitan
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
