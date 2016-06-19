require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.4.0.tgz"
  sha256 "5c6955f86b67a5ecc5eaf71d7dd064f5b4ab94170f66caa27845f5594eb5cc56"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b153f7f1756d030ec0c828263105e48439d36c03d10c18829ed930930c147d66" => :el_capitan
    sha256 "e4cd5aee8f5e9451c4ad669669be37eda5f9c2a0c6ea0016638c93e72aa33af4" => :yosemite
    sha256 "addfa44f0f0b6a77fd345a6ebc1b0737c23567cc17ec81216584402b4d73e4b7" => :mavericks
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
