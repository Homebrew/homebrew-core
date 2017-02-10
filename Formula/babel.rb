require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.22.2.tgz"
  sha256 "209ea6087373d542b8bfb43f5d9188a07ca8864de370fba61ecd03f14cb4eb9a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e282dd9455781b38a7b5999233b619801946f1441cca34a3219eb8d4a41ac8de" => :sierra
    sha256 "af432b33f0fae93335919076bacf0057c3058784189c5f8226eb6566c6c89342" => :el_capitan
    sha256 "d9f4e34dcb54e2d3ef30beb8783a6df93b69732ab7deda987f39361ae23d2d0c" => :yosemite
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
