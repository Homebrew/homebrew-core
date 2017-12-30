require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.1.1.tgz"
  sha256 "beb4374ad2f1425b81958691abd6130afab83ff1d4c8c61f5e75c3e127ef0dc9"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fed77cdce88575f1e3bc1e91c3db73305e38dd1e046b9b491b4e00c7cf65e556" => :high_sierra
    sha256 "0a921b7457096df0124115f00cf43f1eccfdf77b8a29bf239c93ee13e0d9a251" => :sierra
    sha256 "bef83dadc93cc8f5c0e26bfc024db0cb4e1904b5247078625d7f1333cf64f3b7" => :el_capitan
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
