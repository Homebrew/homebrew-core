require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0.tgz"
  sha256 "73a7dcf24ff8207f74182287b68a70ff3010fe8259819a6bd88626962036c14c"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ee15bac1d7c8c140243c8807c3543e12a72143915c639c1a10bfd88363696e8" => :high_sierra
    sha256 "c640d5a16c171689e23f854eff16f8072776676bf456accd2ecb503cbc801062" => :sierra
    sha256 "c5b7b3a88119805725bc3c2cf930efed927fc1bdf24ffa514be084a284475a70" => :el_capitan
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
