require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.5.tgz"
  sha256 "f80dd27d77c4b6110cc4c548c2c026eee7df6c86df2bb047e2a6c30594bba088"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "970d55e99b1a144509611b0adaaf1ddf383428525c39bd801f1eb5dd298d515e" => :mojave
    sha256 "1396c869bd6e91209c5d41902dcd5a5a2018b4f80746d726db606aad98b4cc32" => :high_sierra
    sha256 "9d1b8234b82fcc7839015e3b08364a1a5aa3e431fbcf717f58c777cd43cebb07" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    inreplace libexec/"lib/node_modules/jsdoc/node_modules/requizzle/lib/requizzle.js",
      "if (lookupPaths[0] === targetPath && lookupPaths[1].length === 0) {",
      "if (lookupPaths == null || lookupPaths[0] === targetPath && lookupPaths[1].length === 0) {"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<~EOS
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
