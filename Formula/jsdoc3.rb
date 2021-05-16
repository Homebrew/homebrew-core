require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.7.tgz"
  sha256 "c081fb764e73565c2fbc5cfb559c3d0a6a3d82d337dcf146ece76a2ea17b99b8"
  license "Apache-2.0"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9328c5dc51044e1e036584f9f38e777cf54a0b9280092f276ab1b237e206ed9"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c1da3c8d4fe156dd341effdefc520eda61a622584cde9fbdc307761c0befb87"
    sha256 cellar: :any_skip_relocation, catalina:      "be52878f4ba17b23b50d0d10cd44509029967ab76b6bf7881744181ace44b469"
    sha256 cellar: :any_skip_relocation, mojave:        "c9b323246b713d6e1914cd8b89948c88b2f17a2c2b350edc51f48599e9380b00"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7e4451a0a6726910650d18392c19cfe9e6e2acd477e23e803f73f6e09a38e64c"
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
