require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.11.tgz"
  sha256 "0edcddc7ad9b76d4728ad91b4464362e7fe46d0f11a05e2aab9b1a44686a7664"
  license "Apache-2.0"
  head "https://github.com/jsdoc3/jsdoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fb007f6f5014da402886a97ef3798f04df5cafac4d222dac5d83f6bc54ffefb"
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
