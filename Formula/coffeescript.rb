require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.11.1.tgz"
  sha256 "b004b3a68e1f8b49e81099d5005be222cf49bad06d46979ff22d0184ba667fae"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b69f3fa10ea88f3167f85192a83fb2656e679e702fe86fc6efe336e13f3e9936" => :sierra
    sha256 "f844ac779789b00211c7c96f5b3aceef80d6bac1495a4e8439dd76279721c7db" => :el_capitan
    sha256 "2c03198ce406381677ecf1063fb4180b99d2344cef94058a2c61d3b29e6ee9c4" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.coffee").write <<-EOS.undent
      square = (x) -> x * x
      list = [1, 2, 3, 4, 5]

      math =
        root:   Math.sqrt
        square: square
        cube:   (x) -> x * square x

      cubes = (math.cube num for num in list)
    EOS

    system bin/"coffee", "--compile", "test.coffee"
    assert File.exist?("test.js"), "test.js was not generated"
  end
end
