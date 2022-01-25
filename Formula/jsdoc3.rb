require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.10.tgz"
  sha256 "0032335768ebfb3c11b72814bb332d655da722c3cc634dc097fc498c592aa81c"
  license "Apache-2.0"
  head "https://github.com/jsdoc3/jsdoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d18ac53656e46fd69eef87db5b293f9d54f34edb2de1fb178955116ce522fcc2"
    sha256 cellar: :any_skip_relocation, all:          "3e64a239db726ef68a27275366f6b233aaeae35d8bd331737a4801c8aa03e48e"
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
