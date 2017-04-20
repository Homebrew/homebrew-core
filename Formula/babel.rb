require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.24.1.tgz"
  sha256 "d69a00bdb4f35184cda1f5bfe8075cd4d569600b8e61d864d1f08e360367933b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b4b364e14e7e046d1e3732261e23c1e91a5b9f0063e6dcc341b0cdae086ff9e" => :sierra
    sha256 "426c9de5a3dd170c9264478900f45a292590f48a2c8b51aa0d3ee6650381ec85" => :el_capitan
    sha256 "f7ad8b1845bbecef506586b434e0249859e2bc48be3a165cc94dd5f981c7f800" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<-EOS.undent
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert File.exist?("script-compiled.js"), "script-compiled.js was not generated"
  end
end
