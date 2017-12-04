require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.3.tgz"
  sha256 "5403042e096de453410ff8e5d2e68b64380e1ac1961edd3b85d731e082a2f92a"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d80414d358daca7dda46aa0e84a4296c362434f8ef33f65b360aa735a46cf040" => :high_sierra
    sha256 "6e985b891d8e296b5f00b67930409d2ab7c951105d93a3c8570625494a298d77" => :sierra
    sha256 "2d1c697c42f4fb8d0b9c2472e051c239573adf3e6748e94c6f85e718105e17cc" => :el_capitan
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
