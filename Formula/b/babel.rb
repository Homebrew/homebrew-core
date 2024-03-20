require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.3.tgz"
  sha256 "59b5370260ebdd419e8e3f17318ccfca98a45b7c9886b0fcbd3bf8432027d7ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f64a73137bde3b895a5b22ea6bfd9eef0a43b3659976a27a50bfe756d7f03f6"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.1.tgz"
    sha256 "462d441a9ddce9ab79e233647197d151e72a063e7fd2a323cba50c2d2f514884"
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
