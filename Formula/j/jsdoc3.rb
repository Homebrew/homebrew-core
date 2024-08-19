class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-4.0.3.tgz"
  sha256 "853e0a2d2f32b8bf3b5f7a5730e23ec1cb138a616e066bb2bc658d13c349da57"
  license "Apache-2.0"
  head "https://github.com/jsdoc3/jsdoc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5c02e4c638fff0e80021685a094ecd3946b72135a94f381a0dba2fb96d0a942"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5c02e4c638fff0e80021685a094ecd3946b72135a94f381a0dba2fb96d0a942"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5c02e4c638fff0e80021685a094ecd3946b72135a94f381a0dba2fb96d0a942"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5c02e4c638fff0e80021685a094ecd3946b72135a94f381a0dba2fb96d0a942"
    sha256 cellar: :any_skip_relocation, ventura:        "c5c02e4c638fff0e80021685a094ecd3946b72135a94f381a0dba2fb96d0a942"
    sha256 cellar: :any_skip_relocation, monterey:       "c5c02e4c638fff0e80021685a094ecd3946b72135a94f381a0dba2fb96d0a942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1cc17f8ba31121febe2f7145ef40adac49c4bec475fe1c1c79fc31b40b8e3d5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
