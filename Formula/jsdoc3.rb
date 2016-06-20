require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.4.0.tgz"
  sha256 "5c6955f86b67a5ecc5eaf71d7dd064f5b4ab94170f66caa27845f5594eb5cc56"
  head "https://github.com/jsdoc3/jsdoc.git"

  depends_on "node"

  conflicts_with "jsdoc-toolkit", :because => "both install jsdoc"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
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
