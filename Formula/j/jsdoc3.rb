class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-4.0.5.tgz"
  sha256 "a590c432d7a190fea72445db6b3e2f8d1f457832caa88e617dbb24984141f971"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d86f3f9bc538cb7fa6038821e62cf8aa0bfff3a057799f3aab176894a6c8b21"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<~JS
      /**
       * Represents a formula.
       * @constructor
       * @param {string} name - the name of the formula.
       * @param {string} version - the version of the formula.
       **/
      function Formula(name, version) {}
    JS

    system bin/"jsdoc", "--verbose", "test.js"
  end
end
