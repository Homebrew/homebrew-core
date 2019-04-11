require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.4.1.tgz"
  sha256 "e4f0f957185adf2c7456b0080a7bf9a25e9b5e346c2b66bfb67acb2ac25a8471"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47e4dada1327df33681dd9e8eff5a1bb6450d9cdab1bac5ba4942a3d3c652ce6" => :mojave
    sha256 "12e0dec01386a9543185f86c8b820d1de706cd98cb9013b563508f3346b2158d" => :high_sierra
    sha256 "a4d5bba36cbe559f5d1d944d78749b7d90fe03eb0481064446775d1f7f36e1a3" => :sierra
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
