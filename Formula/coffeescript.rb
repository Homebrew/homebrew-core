require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.3.tgz"
  sha256 "4494ca0cb76924604d773df3fde730b3fceed02cd3f32a905550f750360bc418"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9ec91c0e26ac5ea0c63241e6bb70117f37664cafa57da316b69e76c53b62902" => :sierra
    sha256 "9ab3edd2c2d7e75991793a52565811bce866f278b7f60ce9be72e2e6f7fe75db" => :el_capitan
    sha256 "5044cd36008192f7f680efb2c99cfa8227eab1c00db3952a8911aa9c3702b2b1" => :yosemite
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
