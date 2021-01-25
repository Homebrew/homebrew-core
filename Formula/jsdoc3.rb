require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.6.tgz"
  sha256 "816f44294f01a990df8baf23b420435ad8ebcfc7d4e141576dbeabe8e42879a0"
  license "Apache-2.0"
  head "https://github.com/jsdoc3/jsdoc.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4c1da3c8d4fe156dd341effdefc520eda61a622584cde9fbdc307761c0befb87" => :big_sur
    sha256 "e9328c5dc51044e1e036584f9f38e777cf54a0b9280092f276ab1b237e206ed9" => :arm64_big_sur
    sha256 "be52878f4ba17b23b50d0d10cd44509029967ab76b6bf7881744181ace44b469" => :catalina
    sha256 "c9b323246b713d6e1914cd8b89948c88b2f17a2c2b350edc51f48599e9380b00" => :mojave
    sha256 "7e4451a0a6726910650d18392c19cfe9e6e2acd477e23e803f73f6e09a38e64c" => :high_sierra
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
