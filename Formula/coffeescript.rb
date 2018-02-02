require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.2.0.tgz"
  sha256 "f03d7bfbfaa26946634b674ed8547038e73dff1176bd7dbd2e7128582d3f0177"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc19896704fe1579ae16ed7c1fffdff6d8b6de05d161629b353ebef54878896" => :high_sierra
    sha256 "b744b902fe03d7de100c8bf60e028c6065b94644b876d0f70a7a192580f2c3b3" => :sierra
    sha256 "d03b99d3a6335cb777cb5b3bcfc63378e84f6a687a23cd0e4d133eef9fc94ee6" => :el_capitan
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
