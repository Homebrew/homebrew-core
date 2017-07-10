require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "http://usejsdoc.org/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.5.1.tgz"
  sha256 "b7e504333d04f317a7b62bea21168edd37f49046b84c9080600bb471731b35a6"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39e1745c1030cb3f9afc79c4521b7985d3f3bf9db9f09577fe38a719d425f242" => :sierra
    sha256 "ceb1687c1b16011db4baeeb17382906260cc08024b7dbfa26182d63927ccafeb" => :el_capitan
    sha256 "d307d08a31879470297a9fed1bcb25c602391638da6a33d58be70a09d8f420a1" => :yosemite
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
