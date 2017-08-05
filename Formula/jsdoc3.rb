require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.4.tgz"
  sha256 "7b83936f6bf7f20f65fc179c7b08c25ac955b3d33f619bc70669febdea226dc9"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0839b5f28edce39365a7967aebb58a9e0dd88fff38f36b842fc7f20ffef66f0f" => :sierra
    sha256 "080dc55a6f8ae1a09499cdfe45de8a72429514e017e003151aa18a6208b2485a" => :el_capitan
    sha256 "8e2e44a43e15d03b63cb886273b0e5e0c723632a8165fa63fea15bb21d86e5c7" => :yosemite
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
