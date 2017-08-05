require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.4.tgz"
  sha256 "7b83936f6bf7f20f65fc179c7b08c25ac955b3d33f619bc70669febdea226dc9"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6db6cd10877b88cd13eedcb698da68853ccdf2d616526bbca42030c2be3277c" => :sierra
    sha256 "5233dcfc1a105d02d2a55c78ebde0afd7d433ac854e3bb96d235bf107a5dd90a" => :el_capitan
    sha256 "d901e2b00523f70416676d79366cb2977c00bd77727464e167443a6f45f5fdb1" => :yosemite
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
