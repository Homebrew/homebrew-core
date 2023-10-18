require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.23.2.tgz"
  sha256 "c59f94b3ab97a4f3d8265d7413b2e967a1b8a8a44efc4a384ca98080f88beb3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa378ea1dcef59ab709c55c2e3de076ad262616346978285dddfdf835c2391f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa378ea1dcef59ab709c55c2e3de076ad262616346978285dddfdf835c2391f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa378ea1dcef59ab709c55c2e3de076ad262616346978285dddfdf835c2391f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa378ea1dcef59ab709c55c2e3de076ad262616346978285dddfdf835c2391f2"
    sha256 cellar: :any_skip_relocation, ventura:        "aa378ea1dcef59ab709c55c2e3de076ad262616346978285dddfdf835c2391f2"
    sha256 cellar: :any_skip_relocation, monterey:       "aa378ea1dcef59ab709c55c2e3de076ad262616346978285dddfdf835c2391f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "174fe44e0a2c8d2e44848dfca87fed6caab376c8bc1f8a9784e9bba9bc47bfdd"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.23.0.tgz"
    sha256 "3c47bb2c36fd66e39ab5c62bdcf47b20dadcd62fd45ad62c2d1c1699af23c2b2"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
