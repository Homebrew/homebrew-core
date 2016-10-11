require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.4.2.tgz"
  sha256 "f7d3caf34c6ba08fe0a516de0a745bab1ffa4a04b44421835f0432592dda9fee"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e80fd0f88342d0267ddacffaf91e65fd2194a67cc165deb1822df7d80108a39" => :sierra
    sha256 "7c35f32ce1592cef6ce4506d4319c623f935916bf09d08dc611f15b38afb1d9b" => :el_capitan
    sha256 "76e54cee5ccea67306fa1986b3ce81a491a869881f1c10884c698210e2da3eea" => :yosemite
  end

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
