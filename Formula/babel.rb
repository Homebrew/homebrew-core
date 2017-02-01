require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.22.2.tgz"
  sha256 "209ea6087373d542b8bfb43f5d9188a07ca8864de370fba61ecd03f14cb4eb9a"

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
