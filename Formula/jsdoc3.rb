require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.1.tgz"
  sha256 "b7e504333d04f317a7b62bea21168edd37f49046b84c9080600bb471731b35a6"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6492f8807cb2cd3beb24bc3f8d47b883794c05afa1ca939dca0b42bfedfd4032" => :sierra
    sha256 "ac9e284a94fd0c4395241956f7485ac8775432d2fa1cd97e3acf2d24374f3264" => :el_capitan
    sha256 "9e9a5edd5a22e467cfb4ad6e37b7383993042de4ff9b12f6815058e1f0a974aa" => :yosemite
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
