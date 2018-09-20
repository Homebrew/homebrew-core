require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.3.2.tgz"
  sha256 "c74eb245cbd411eefc34d44bc2570b470682c434e029afac9ece0175db9faa5a"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a34ee70f2b0806edf10c621a777bcab5b674b6a2c3babb21a62637175b79052" => :mojave
    sha256 "49da6599ee49ee6644fbb8cef4da0f333a36e5169b49882e151ea95c3e0288c5" => :high_sierra
    sha256 "bbb0b28041b6aa10e4730d1cafa2e682438fb7384165651cf4b6ab72386fd669" => :sierra
    sha256 "750778791fbd6e5896a10bacc345ca18bbb28e29abd270227f4bbfc73d7426c1" => :el_capitan
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
