require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0.tgz"
  sha256 "73a7dcf24ff8207f74182287b68a70ff3010fe8259819a6bd88626962036c14c"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6f2ee89cc482e2949fba26b85dcf68f79908d51453e1ebfbc691887d11375eb7" => :high_sierra
    sha256 "36501a7dc6e14ffca4009848e9aeee3958c1ed2f66cb2a8384a960c5cadeb0ef" => :sierra
    sha256 "7310cdbb6f272f1eb084a82540f09bf9eff97ebfa4a291b9bd5634b2045492cd" => :el_capitan
    sha256 "8516cacd1700b329b9610697926199f5200554b720d9f1c6a7b3419fb41ac7e8" => :yosemite
  end

  depends_on "node"

  conflicts_with "cake", :because => "both install `cake` binaries"

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
