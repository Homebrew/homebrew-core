require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.1.1.tgz"
  sha256 "beb4374ad2f1425b81958691abd6130afab83ff1d4c8c61f5e75c3e127ef0dc9"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d278695c911dfe541966de5bdfd985b7d10d4aadaf197c2a093f29c344a9beca" => :high_sierra
    sha256 "0c078b2ce55e70b9e226fa159e5ee4f5be33180c1bca6d9ccbbefff80980846f" => :sierra
    sha256 "faa22f66588159fc284bfc78f1e4a627ed7a6b14f8069adc44b5a51af1333f06" => :el_capitan
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
