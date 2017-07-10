require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.0.tgz"
  sha256 "7ef0e7714d3bf3af1bba66049fe3d831b0d83772f1e6adaa5216778ed50d18d6"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05b19f6416176a148d4378a513ccb97162d39dfc7e1eb334ee847a255864c614" => :sierra
    sha256 "a20047ed1604c540600e93726a072dd26c7050b0f100459047f01b8bd4388aa9" => :el_capitan
    sha256 "3d1035d8d1ff7bd705d8b9ae2b3a00e1f969be6cdb1843c594924302e3de918d" => :yosemite
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
