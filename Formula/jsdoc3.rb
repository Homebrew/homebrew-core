require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.4.2.tgz"
  sha256 "f7d3caf34c6ba08fe0a516de0a745bab1ffa4a04b44421835f0432592dda9fee"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0288d38dc34a7ccd5b253145c55547fb47008f1ea157dc2d12dcbc851ccc4226" => :sierra
    sha256 "601e03f9cbfe83dfbae0b63b6fa4a2a0d8ded62a8b3f019a2852e47fd957b79f" => :el_capitan
    sha256 "adceb946ab836b50f6316963275309abb54c3be6b7eb9e1aac7c964b068a66f8" => :yosemite
    sha256 "9c71b6167ef567af5d40f301539f1789f483f761821868e75eb01d3d2927d470" => :mavericks
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
