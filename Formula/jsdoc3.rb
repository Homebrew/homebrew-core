require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.5.tgz"
  sha256 "f80dd27d77c4b6110cc4c548c2c026eee7df6c86df2bb047e2a6c30594bba088"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5d72fa1fb4ab24ce45b70e98ef8ee823a772794b54cc78fc859e41ac27e8687" => :mojave
    sha256 "746c92b92e292189a958f35739ebd267f0a861e33cdd5c08026da3d255d92ad7" => :high_sierra
    sha256 "bfab5fccdd1e49260dc2166af13885de94d43acb7cc689663aa0414cef88698a" => :sierra
    sha256 "9d5a8b63309f02f86c42c7cf6973a000f4eda4ad0e1cea080a64674abea0a2da" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
