require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.2.tgz"
  sha256 "c77cc751c5a9f13d75eb337fbb0adec99e7bfdd383f12e2789ddaabb64d14880"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "120e522b28e30c7e84ddaa3c351575803809b540204123bb095c28d1c8c09a73" => :sierra
    sha256 "3c356a905826767fc74c2626e1fba4c9e25ae2bcfb94a189698ad76303f3d89f" => :el_capitan
    sha256 "226700607d9fd9b6401281de7523e2412deff70f3abf18ffcd2b0f13c684682c" => :yosemite
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
