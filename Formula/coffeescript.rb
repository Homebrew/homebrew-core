require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-1.12.7.tgz"
  sha256 "307640c6bf0d7ac51f6ba41fc329a88487d7d4be4cdadd33200ceaf4e6977992"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    sha256 "3233c84d47401b4a81d421d753266327ab1ca0c6b150ca55e36ea341aedfcf04" => :sierra
    sha256 "577dff5471803146d9d6c26c8508844328bbe63716a0d423d384373c5906b854" => :el_capitan
    sha256 "2083e255c330be447e54586c69ebe1e65eff1ff5c0524e170f153fd861bdca6c" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta3.tgz"
    sha256 "b4b63767f750a4ec16a3be87b1fd8c1006a4b7f65bbc5dcc16b523f177e1cd3b"
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
