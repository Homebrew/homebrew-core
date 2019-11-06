require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.4.1.tgz"
  sha256 "e4f0f957185adf2c7456b0080a7bf9a25e9b5e346c2b66bfb67acb2ac25a8471"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9735256a21c36c30fb29a9de0c0c0cbb15dd8d29e315522f55afcd3f285fc8ad" => :catalina
    sha256 "9c1bf5218600450ce9f3e8ed18e762f38d066d313f2d7ad198c8c0ffd7a7ad38" => :mojave
    sha256 "46c1294c0ddabe9e77e83a1a43e2ce26c91c88f8831c0134fd4806704fc6838c" => :high_sierra
    sha256 "eee1074f188cb64062d88a72c43e156230a358d207eb22959ff10c3b77545854" => :sierra
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
