require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.2.tgz"
  sha256 "8544c5087203111249cd15b9576ee4d95d7d7e371e7b47bd89963da9e2895ed8"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2090e24d6b5bb91b5179e036e89105f4d6975d254284ebf7ff5642cf07990c9c" => :sierra
    sha256 "71549c405186b6230a9145dc10527e530852703d673abae0a127e4643352fc7d" => :el_capitan
    sha256 "4ac032304137e81860a4ea5aecbe62314f8f9c075f6697b26e881225b34f51b9" => :yosemite
  end

  depends_on "node"

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
