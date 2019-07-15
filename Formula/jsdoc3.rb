require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.3.tgz"
  sha256 "e5f5f08854cb821d6196fe7b438b80372c67be16eb0f45c6ea22b5b741379dcd"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3dbe47d0b9c325e1688a7b96691119beee2f65c16a15eda674b7a4ee17251af" => :mojave
    sha256 "9c7edd88f94bbbb7f302cd0da115aed76ccca398ef374d09a446de678f005bec" => :high_sierra
    sha256 "4083d0193dd4fd7055e2232e14303751dec9f5b664dd543f7986c149c9eba8d5" => :sierra
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
