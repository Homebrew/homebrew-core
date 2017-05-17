require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-1.12.6.tgz"
  sha256 "9d238f34cd8130c0011d305d94316844d39bbf9472dfe550b7596105b8de3b6f"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3f79fca4a47118f65e737d7c3015525104358f2851c3908083ccd5ef6cdca28" => :sierra
    sha256 "8994446d1a9b000214469352d38bc4709e59aaf90647caf61177d4963833c176" => :el_capitan
    sha256 "c481a5a22c6328a050875192513b9b9b644bd93f1712abdb3b37ad0125a83c03" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta1.tgz"
    sha256 "9976d3f9594209bcfbedfe290abcc3a8ec8767f698425cfd2bc1419a6e5589a7"
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
