require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.0.tgz"
  sha256 "bc5dfd65cba7686b0fa207a62eabc62d0a4386a84ae5946a294f47fca14fe9d0"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce39f1f86e25fbd4b8148b30ef8c986c69fdee01f6dddea1f5918f96c69ecabc" => :sierra
    sha256 "0d99dde7273b606b4ad2a19da83ed4feb5db7f2802b02bdc1264373ba1fa23ac" => :el_capitan
    sha256 "4fe69d0d12e963129181616a786dc7a9f572ecedbda119338e577e573c57d2e5" => :yosemite
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
