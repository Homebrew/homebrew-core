require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.5.tgz"
  sha256 "be282a5ad3c257d0a93c926f71e16ff6765b6d01f142a0fe5efc02a6765a7ac7"
  license "Apache-2.0"
  head "https://github.com/jsdoc3/jsdoc.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f27ce46b59636cf0b06c0857e59c5cc7de89f59524e1597c0efd05d48d02299a" => :catalina
    sha256 "d33bd4efc75166f484d496cfc58d1273bb6f42a73f220841efdaca1e54be37ce" => :mojave
    sha256 "47d6b79de54abbd92259da7b2101125158a07949195e760ab385fd088c086379" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<~EOS
      /**
       * Represents a formula.
       * @constructor
       * @param {string} name - the name of the formula.
       * @param {string} version - the version of the formula.
       **/
      function Formula(name, version) {}
    EOS

    system bin/"jsdoc", "--verbose", "test.js"
  end
end
