require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.2.1.tgz"
  sha256 "78838f7e8fd1c002856739e6a1215f3f5f2bc5c24ecb9f587f1bc46f26dd45e0"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebebe86bf0d4ad918ccf2ab0189da952482a62db44813f6e8fb461c4012ec3a1" => :high_sierra
    sha256 "09c66f7280486255861d5b53ea2b79387450f73c5038d8e0a18146cc32a07ee5" => :sierra
    sha256 "29711a1c7f6c9b2f7bc192b3f9af74a68f3136b3f524724cc204cbbc08a965a3" => :el_capitan
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
